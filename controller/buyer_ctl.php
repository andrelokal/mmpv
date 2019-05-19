<?php

class buyer_ctl extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	function __construct(){
		$this->table = 'fisica';
	}

	function save( $request = NULL, $before = NULL, $after = NULL){
		
		$db = Database::getInstance();
		$db->begin_transaction();

		$request = json_decode($request, true);

		foreach ($request as $key => $value) {
			if( preg_match("/^venda_/", $key) ) unset( $request[$key] );
		}

		if( !$request['id'] ){
			
			$pessoa = new pessoa();
			if( $pessoa->save( [ "status" => "AT", "tipo" => "F" ] ) ){
				$request['pessoa_id'] = $pessoa->id;	
			} else {
				$this->msg = "Erro ao criar pessoa";
				$db->rollback();
				return false;
			}			
		} 
		

		if( parent::save( $request )){
			$db->commit();
			return true;
		} else {
			$db->rollback();
			return false;
		}
	}

	function selectAll( $offset = "",$rows = "", $active="" ){

		$table = new $this->table();
		$table	->select( '*')
				->grid();
		
		$return = $table->output();
		if( $table->num_rows ){

			$this->data = $return->data;
			$this->msg = "";
			return true;

		} else {

			$this->msg = "...";
			return false;	
		}
	}

	function selectById( $id ){

		$produto = new $this->table($id);
		if( $produto->id ){
            
            $this->data = (object) $produto->result;	
            if( $produto->tem_conta == 'y' ) $this->data->saldo = $this->dadosConta( $id );
					
			$this->msg = "";
			return true;

		} else {
			//$this->msg = $func->query;
			$this->msg = "Erro ao encontrar cliente!";
			return false;	
		}

	}

	private function dadosConta( $id ){

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

	
	function selectByCPF($cpf){

		$fisica = new $this->table;
            
        $table = new $this->table();
		$table	->select( '*')
				->where( " cpf = '". $cpf ."' " )
				->grid();
		
		$return = $table->output();
		if( $table->num_rows ){

			$this->data = $return->data[0];
			$this->msg = "";
			return true;

		} else {

			$this->msg = "Cliente não encontrado";
			return false;	
		}
    
    }

    function selectByTelefone( $telefone ){

    	$fisica = new $this->table;
            
        $table = new $this->table();
		$table	->select( '*')
				->where( " telefone = '". $telefone ."' " )
				->grid();
		
		$return = $table->output();
		if( $table->num_rows ){

			$this->data = $return->data[0];
			$this->msg = "";
			return true;

		} else {

			$this->msg = "Cliente não encontrado";
			return false;	
		}
    }

	
}