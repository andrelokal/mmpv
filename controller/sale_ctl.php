<?php

class sale_ctl extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	public $filter = "";

	function __construct(){
		$this->table = 'venda';
	}

    function selectAll( $offset = "",$rows = "",$tem_estoque="" ){

        $normalize = new normalize();
        $table = new $this->table();
        $table->limit = 5;
        
        $where = [];

        if( $this->filter ){
            $where = [];
            foreach ($this->filter as $key => $value) {

                // confere se é data
                if( preg_match( '/[0-9]{2}\/[0-9]{2}\/[0-9]{4}.*/', $value ) ){
                    $where[] = $key." >= '".  $normalize->date_mysql($value) ."' ";
                } else if( strpos(' '.$value,'%') ){
                    $where[] = $key." LIKE '".$value."' ";    
                } else {
                    $where[] = $key." = '".$value."' ";    
                }                    
            }                
        }

        $where[] = " status != 'C' ";
        if( count( $where ) ) $where = implode(" AND ", $where );      

        $table  ->select( 'id')
                ->select( 'total')
                ->select( 'data', 'data',NULL,'date_format')     
                ->where( $where )
                ->grid();
        //echo $table->query;
        $return = $table->output();
        if( $table->num_rows ){

            $this->data = $return->data;
            $this->msg = "";
            return true;

        } else {

            $this->msg = "Nenhum registro encontrado";
            return false;   
        }
    }

	function save( $request = NULL, $before = NULL, $after = NULL){

        $venda_id = null;
		$db = Database::getInstance();
		$db->begin_transaction();

		$total_venda = 0;

		// Verifica caixa aberto
        $caixa = new caixa_ctl();
        if( !$caixa->check_caixa_aberto() ){
            $this->msg = 'Nenhum caixa aberto!';
            return false;
        } else {
            // seta id caixa
            $caixa_id = $caixa->data['id'];
        }

        // Verifica mesa
        $mesa_selected = ( array_key_exists('mesa_selected', $_SESSION['logged']) ? $_SESSION['logged']['mesa_selected'] : "" );
        if( $mesa_selected ){
            $sql = "UPDATE  comanda_mesa 
                    SET     status = 'O' ,
                            dt_status_O = NOW()
                    WHERE   status = 'L' AND 
                            id = '". $mesa_selected ."' ";
                            //echo $sql;
            $db->query($sql);


            $sql = "SELECT  venda_id, status
                    FROM    comanda_mesa 
                    WHERE   id = '". $mesa_selected ."' ";
                            //echo $sql;
            $result = $db->query($sql);
            $row = $result->fetch_assoc();
            $venda_id = $row['venda_id'];
            $status_mesa = $row['status'];

        }
        // Cria ID venda
        $post = json_decode($request, true);

        // INFORMAÇÕES DEVLIERY
        $delivery = false;
        $troco = 0;
        $delivery_forma = '';

        if( array_key_exists('delivery', $post) ){
            $delivery = $post['delivery'];
            $troco = $post['troco'];
            $delivery_forma = $post['delivery_forma'];
        }
        

        $table = new $this->table( $venda_id );
        
        if( !$venda_id ){
            $table->caixa_id = $caixa_id;
            $table->comanda_mesa_id = $mesa_selected ;
            $success = $table->save();
            if( !$success ){
                $db->rollback();
                $this->msg = $table->msg;
                return false;  

            }
            // Pega ID da Venda
            $venda_id = $table->id;
            $NrPedido = str_pad( substr( $venda_id , -2) , 2, "0", STR_PAD_LEFT );
            $table->NrPedido = $NrPedido;

            if( $mesa_selected ){
                $sql = "UPDATE  comanda_mesa 
                        SET     venda_id = '".$venda_id."' 
                        WHERE   id = '". $mesa_selected ."' ";
                                //echo $sql;
                $db->query($sql);
            }
        } 
        
        if( $mesa_selected && $venda_id ){
            $delete = " DELETE  FROM itens_venda 
                        WHERE   venda_id = '". $venda_id ."' AND 
                                status IN ('E','X') ";
            $db->query($delete);
        }

        $pizza_tm = 0;

        // cria instancia ItenVenda
		$itens_venda = new itens_venda;
		$prod = new produto();
		// Adiciona Itens da Venda 

        // Verifica se é uma pizza
        if( $prod->categoria_id == 4 ){

        }

        foreach( $post['itens'] as $pi ){
            $prod->setid( $pi['produto_id'] );
            $quant = $pi['quantidade']; 
            $venda_vl = $this->CalcItem( $prod, $pi['valor_item'], $quant );

            if( $prod->categoria_id == 4 && 
                $quant < 1 ){
                $pizza_tm += $quant;
            }

			$total_venda += $venda_vl;
            // Regras
            /*
                Mesa e/ou Delivery ? Em Andamento
                Se não : Concluido                
            */
            $itens_venda->status = $prod->status_inicial;
			$itens_venda->venda_id = $venda_id;
			$itens_venda->produto_id = $pi['produto_id'];
			$itens_venda->quantidade = $quant;
			$itens_venda->valor_unitario = $venda_vl;
            $itens_venda->descricao = $pi['descricao']; 
            $itens_venda->id = null;
			if( $itens_venda->save()){
				
				// Decrementa Estoque Produto
				/*if( $prod->tem_estoque == 'y' )*/ $prod->estoque -= $quant;
				if( !$prod->save()){

					$db->rollback();
                    $this->msg = $prod->msg;
                    return false;  

				}

			} else {
				// Erro ao gravar Item
				$db->rollback();
				$this->msg = "Erro ao gravar item ";
				return false;
			}
		}

        // Verifica se tem itens da mesa a serem lançados
        // TEM MESA - itens já gravados
        if( $mesa_selected ){
            
           $sql =  "SELECT  id, produto_id, quantidade, valor_unitario
                    FROM    itens_venda 
                    WHERE   venda_id = '". $venda_id ."' AND 
                            status != 'X' ";
                            //echo $sql;
            $resItens = $db->query($sql);
            while( $row = $resItens->fetch_assoc() ){
                $prod->setid( $row['produto_id'] );
                $quant = $row['quantidade']; 
                $venda_vl = $this->CalcItem( $prod, $row['valor_unitario'], $quant );
                $total_venda += $venda_vl;
            }      
        }

        /*Verifica se as pizzas estão inteiras*/
        if( $pizza_tm ){

            if( ( ceil( $pizza_tm / 1 ) - $pizza_tm ) ){
                $db->rollback();
                $this->msg = "Tem pizzas que não estão inteiras!";
                return false;
            }                        
        }

        if( !isset($post['forma']) &&
            !$mesa_selected ){

            $this->msg = "Não tem forma de pagamento";
            return false;
        }

        if( isset($post['forma']) ){
            // Itens registrados? 
            // calcula total com desconto
            $total_calc = $total_venda - $this->Discount( $total_venda, $post['desconto'] );
            // Registrar Total
            $table->total = $total_calc;

            // FRACIONADO
            // Fracinou?
            if( array_key_exists('fracionado', $post) ){
                // Soma os total da soma do fracionado
                $total_fracionado = array_sum( $post['fracionado'] );
                // se for maior que o total da compra 
                // TEM TROCO    
                if( $total_fracionado > $total_calc ){
                    $troco = $total_fracionado - $total_calc;
                    if( $troco > $post['fracionado'][1]){
                        $db->rollback();
                        $this->msg = "Troco Fracionado não pode ser maior que a quantia em dinheiro";
                        return false;  
                    } else {
                        //Acerta troco fracionado
                        $post['fracionado'][1] -= $troco;
                    }
                }
            } 


            // FORMAS DE PAGAMENTO
            $VendaPagto = new venda_pagto();
            // Gravar Formas Pagamento
            switch( $post['forma'] ){
                case 5: // Fracionado

                    foreach ($post['fracionado'] as $key => $value) {
                        if( $value ){
                            $VendaPagto->id = NULL;
                            $VendaPagto->venda_id = $venda_id;
                            $VendaPagto->forma_pagto_id = $key;
                            $VendaPagto->valor = $value;
                            if( $VendaPagto->save()){
                                if( $key == 4 ){
                                   if( !$this->AddDebitoContaCliente( $post['fisica_id'], $value, $caixa_id, $venda_id ) ){
                                        $db->rollback();
                                        $this->msg = "Erro ao gravar forma Fracionado para Cliente";
                                        return false;
                                   }
                                }
                            } else {
                                $db->rollback();
                                $this->msg = "Erro ao gravar forma Fracionado";
                                return false;
                            } 

                            
                        }                                
                    }                            

                    break;

                case 4: // Jogar conta corrente cliente
                    //$GLOBALS['break'] = 1;
                    $this->AddDebitoContaCliente( $post['fisica_id'], $total_calc, $caixa_id, $venda_id );
                    // Sem break para cadastrar forma TB

                default : 
                    //$GLOBALS['break'] = 1;
                    $VendaPagto->venda_id = $venda_id;
                    $VendaPagto->forma_pagto_id = $post['forma'];
                    $VendaPagto->valor = $total_calc;
                    if( !$VendaPagto->save()){
                        $db->rollback();
                        $this->msg = $VendaPagto->msg;
                        return false;
                    }

                    break;
            }    

            $table->desconto = $post['desconto'];
        }
		
        // MESA ou Delivery ? Status = Aberto
        $table->status = ( $mesa_selected or $delivery ? "A" : "F" ) ;
        
        // grava a venda
        if( $table->save() ){
        	
            if( $mesa_selected && isset($post['forma'])){
                $sql = "UPDATE  comanda_mesa 
                        SET     status = 'L',
                                dt_status_O = NOW(),
                                venda_id = NULL 
                        WHERE   id = '". $mesa_selected ."' ";
                if( $db->query($sql) ){
                    $_SESSION['logged']['mesa_selected'] = null;
                } else {
                    $db->rollback();
                    $this->msg = 'Erro ao fechar mesa!';
                    return false;
                }
            }

            // Registra Delivery
            if( $delivery ){

                $dlvry = new delivery();
                if( !$dlvry->save( [
                                "venda_id"  => $venda_id,
                                "forma"     => $delivery_forma,
                                "troco"     => $troco
                              ])){
                    $db->rollback();
                    $this->msg = 'Erro ao gravar delivery!';
                    return false;
                }

            } else {

                /*$sql = "UPDATE  itens_venda 
                        SET     status = 'C'
                        WHERE   venda_id = '". $venda_id ."' AND 
                                status != 'X' ";
                if( !$db->query($sql) ){                   
                    $db->rollback();
                    $this->msg = 'Erro ao concluir itens da venda!';
                    return false;
                }

                $sql = "UPDATE  venda 
                        SET     status = 'F'
                        WHERE   venda_id = '". $venda_id ."' AND 
                                status != 'X' ";
                if( !$db->query($sql) ){                   
                    $db->rollback();
                    $this->msg = 'Erro ao concluir itens da venda!';
                    return false;
                }*/
            }   


        	$db->commit();
            $this->data = [ "mesa_id" => $mesa_selected ];
        	$this->msg = 'Venda gravada com sucesso!';
        	return true;

        } else {
        	$db->rollback();
			$this->msg = 'Erro ao gravar venda!';
			return false;
        }       
	}

    private function CalcItem( $prod,$venda_vl, $quant ){

        $prod_vl = $prod->valor;
        $proc_un = $prod->unidade_id;
        // unidade != Livre
        if ($proc_un != 2) {
            $venda_vl = $quant * $prod_vl;
        }

        return $venda_vl;
    }

	private function Discount( $vlr, $discount ){
        return ( $vlr * (float) $discount ) / 100;
    }

    private function AddDebitoContaCliente( $fisica_id, $vlr, $caixa_id, $venda_id ){
        //$GLOBALS['break'] = 1;
        $FisicaConta = new fisica_conta();

        $FisicaConta->fisica_id = $fisica_id;
        $FisicaConta->tipo = 'D';
        $FisicaConta->valor = $vlr;
        $FisicaConta->dt_cadastro = NULL;
        $FisicaConta->desconto = 0;
        $FisicaConta->caixa_id = $caixa_id;
        $FisicaConta->venda_id = $venda_id;

        return $FisicaConta->save();

    }

	
}