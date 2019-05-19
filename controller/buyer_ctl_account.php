<?php

class buyer_ctl_account extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	function __construct(){
		$this->table = 'fisica_conta';
	}

	function save( $request = NULL, $before = NULL, $after = NULL){
		
		$db = Database::getInstance();
		$db->begin_transaction();

		// Verifica caixa aberto
        $caixa = new caixa_ctl();
        if( !$caixa->check_caixa_aberto() ){
            $this->msg = 'Nenhum caixa aberto!';
            return false;
        } else {
            // seta id caixa
            $caixa_id = $caixa->data['id'];
        }

        $post = json_decode($request, true);	

        // saldo
        $saldo = $this->saldo( $post['fisica_id'] );
        if( $saldo === false ){
        	$db->rollback();
			$this->msg = 'Erro ao pegar saldo!';
			return false;
        }

        // calcula saldo - pago
        $pago = $post['valor'];
        $saldo_atual = $saldo + $pago;
        $troco = $pago + $saldo;

        if( $saldo_atual > 0 ){ // saldo positivo
        	if( $post['forma_pagto_id'] != 1 ){

                // Fracionado
                if( $post['forma_pagto_id'] == 5 ){

                    // tem parte em dinheiro ?
                    if( $post['fracionado'][1] ){
                        
                        // Se o saldo for maior que a parte em dinheiro
                        if( $saldo_atual > $post['fracionado'][1] ){
                            $this->msg = 'O troco ( R$ <b>'.number_format($troco,2,',','.').'</b> ) não pode ser maior que quantia em dinheiro ( R$ <b>'.number_format($post['fracionado'][1],2,',','.').'</b> )! ';
                            return false;     
                        } else {
                            // acerta o troco
                            $post['fracionado'][1] -= $troco;
                        }                          
                        
                    } else {
                        $this->msg = "Pagamento com <b>cartão</b> não pode haver troco!";
                        return false; 
                    }                       

                      

                } else {
                    $this->msg = "Pagamento com <b>cartão</b> não pode haver troco!";
                    return false;    
                }
                
            }    
        }

        // acerta o troco
        if( $troco > 0 ) $pago -= $troco;

        $table = new $this->table();
        $table->tipo = 'C';
        $table->desconto = $post['desconto'];
        $table->fisica_id = $post['fisica_id'];
        $table->valor = $pago;
        $table->caixa_id = $caixa_id;

        // grava a venda
        if( $table->save()){
        
        	$VendaPagto = new venda_pagto();
            // Gravar formas de pagamento
            switch( $post['forma_pagto_id'] ){
                case 5: // Fracionado

                    foreach ($post['fracionado'] as $key => $value) {
                        if( $value ){
                            $VendaPagto->fisica_conta_id = $table->id;
                            $VendaPagto->forma_pagto_id = $key;
                            $VendaPagto->valor = $value;
                            
                            if( !$VendaPagto->save()){
                            	$db->rollback();
								$this->msg = 'Erro ao gravar forma fracionado!';
								return false;
                            }  
                        }                                
                    }                            

                    break;

                default : 

                    $VendaPagto->forma_pagto_id = $post['forma_pagto_id'];
                    $VendaPagto->valor = $pago;
                    $VendaPagto->fisica_conta_id = $table->id;
                    if( !$VendaPagto->save()){
                    	$db->rollback();
						$this->msg = 'Erro ao gravar forma pagto!';
						return false;
                    }  

                    break;
            }

        	$db->commit();
        	$this->msg = 'Sucesso!';
        	return true;

        } else {
        	$db->rollback();
			$this->msg = 'Erro ao gravar pagamento!';
			return false;
        }       
	}

	private function saldo( $id ){

		$table = new $this->table();
        $response = $table->sqlExec(" SELECT 	@creditos := IFNULL(( 	SELECT 	SUM( IF( A.desconto > 0 , (( A.valor * 100 / ( 100 - A.desconto )) - A.valor) + A.valor  , A.valor) )
																	FROM 	fisica_conta A 
																	WHERE 	A.fisica_id = '".$id."' AND 
																		  	A.tipo = 'C' ) ,0),
												
											@debitos := IFNULL((	SELECT 	SUM( A.valor )
																	FROM 	fisica_conta A JOIN 
																			venda B ON A.venda_id = B.id
																	WHERE 	A.fisica_id = '".$id."' AND 
																		  	A.tipo = 'D' AND 
																		  	B.status != 'C' ),0),
											@creditos AS creditos,
											@debitos AS debitos,
											( @creditos - @debitos ) AS total ");

 		if($response->result->num_rows){
            
        	$row = $response->result->fetch_assoc();
            return $row['total'];

        }else{
            
            $this->msg = "Opss!";
            return false;

        }

    }




	
}