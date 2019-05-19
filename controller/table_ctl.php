<?php

class table_ctl extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	function __construct(){
		$this->table = 'comanda_mesa';
	}

	function selectAll( $offset = "",$rows = "", $active="" ){

		$table = new $this->table();
		$table	->select('id')
				->select('codigo')
				->select( 'status')
				->select( 'status',NULL,"status_text",NULL,true,10," CASE a.status WHEN 'L' THEN 'Livre' WHEN 'O' THEN 'Ocupada' WHEN 'P' THEN 'Pagamento' END ")
				->select( 'dt_status_O', '','dt_status_O','date_format',true,10)
				->where( " active = 'y' " )
				->grid();

		
		$return = $table->output();
		if( $table->num_rows ){

			$this->data['itens'] = $return->data;
			$this->data['selected'] = ( array_key_exists('mesa_selected', $_SESSION['logged']) ? $_SESSION['logged']['mesa_selected'] : "" ) ;
			$this->msg = "";
			return true;

		} else {

			$this->msg = "...";
			return false;	
		}
	}

	function setMesa( $id = null ){

		if( !$id ){
			$_SESSION['logged']['mesa_selected'] = null;
			return true ;
		} 
		
		$db = Database::getInstance();
		$sql = "SELECT 	p.id, 
						CONCAT( '(', p.codigo ,') ', p.nome) AS nome,
						a.quantidade,
						a.valor_unitario,
						a.status,
						a.id AS item_id

				FROM itens_venda a
				JOIN produto p ON a.produto_id = p.id 
				JOIN venda b ON b.id = a.venda_id
				JOIN comanda_mesa c ON c.id = b.comanda_mesa_id
				WHERE 	b.data >= c.dt_status_O AND 
						c.active = 'y' AND 
						c.id = '". $id ."'  ";
		//echo $sql;
		$result = $db->query( $sql );

		if( $result->num_rows ){

			while( $row = $result->fetch_assoc() ){
				$this->data[] = $row;
			}
						
		}

		return (boolean) ( $_SESSION['logged']['mesa_selected'] = $id );

	}

	function destroyMesa( ){
		
		if( !$_SESSION['logged']['mesa_selected'] ){
			$this->msg = "Mesa não selecionada";
			return true ;
		}

		$db = Database::getInstance();
		$sql = "UPDATE  comanda_mesa 
                SET     status = 'L',
                        dt_status_O = NOW(),
                        venda_id = NULL 
                WHERE   id = '". $_SESSION['logged']['mesa_selected'] ."' ";
        if( $db->query($sql) ){
            $_SESSION['logged']['mesa_selected'] = null;
        }

        $result = $db->query( $sql );

		if( $result ){

			$this->msg = "Mesa liberada com sucesso!";
			return true;
						
		} else {

			$this->msg = "Erro a liberar mesa";
			return false;

		}

		

	}

	function PagarMesa(){
		$db = Database::getInstance();
		$id = ( array_key_exists('mesa_selected', $_SESSION['logged']) ? $_SESSION['logged']['mesa_selected'] : "" );
		if( !$id ) return false;

		$sql = "UPDATE  comanda_mesa 
                SET     status = 'P' 
                WHERE   id = '". $id ."' ";
        if( $db->query($sql) ){
        	$_SESSION['logged']['mesa_selected'] = null;
        	return $db->query($sql);	
        } else {
        	return false;
        }


	}

	function cancelItem( $id ){
		$db = Database::getInstance();
		$sql = "SELECT  b.comanda_mesa_id
                FROM    itens_venda a JOIN 
                		venda b ON a.venda_id = b.id 
                WHERE   a.id = '". $id ."' ";
                        //echo $sql;
        $result = $db->query($sql);
        $row = $result->fetch_assoc();
        $comanda_mesa_id = $row['comanda_mesa_id'];

		$delete = " DELETE  FROM itens_venda 
                    WHERE   id = '". $id ."' ";
        if( $db->query($delete)){
        	$this->data = ["mesa_id" => $comanda_mesa_id ];
        	return true;
        } else {
        	return false;
        }

	}

	



	
}