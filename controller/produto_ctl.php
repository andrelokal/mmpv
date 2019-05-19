<?php

class produto_ctl extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	
	function __construct(){
		$this->table = 'produto';
	}

	function selectAll( $offset = "",$rows = "",$tem_estoque="" ){

		$table = new $this->table();

		if( $this->search ){
			$table->addFilter('id',$this->search,"=","OR");
			$table->addFilter('nome','%'.$this->search.'%',"like","OR");
			$table->addFilter('codigo','%'.$this->search.'%',"like","OR");
			$table->addFilter('codbar','%'.$this->search.'%',"like","OR");
			$table->addFilter('descricao','%'.$this->search.'%',"like","OR");
			$table->addFilter('categoria.nome','%'.$this->search.'%',"like","OR");
		}		

		$table	->select('*')
				->select('categoria.nome','Categoria','categoria')
				->join('categoria', 'categoria_id', 'join', 'id')
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

	function selectBycode( $codigo ){

		$produto = new $this->table();
		$produto->limit = 1;
		$produto->select('id')
				->select('valor')
				->select('unidade_id')
				->select('categoria_id')
				->select('tem_estoque')
				->select('estoque_min')
				->select('estoque')
				->select('nome')
				->select('codigo')
				->where(" ( a.codigo = '".$codigo."' OR a.codbar = '".$codigo."' ) AND
                          ( CASE  	WHEN a.tem_estoque = 'y' THEN a.estoque > 0 ELSE 1 END ) = 1 ")
				->grid();

        $return = $produto->output();
		if( $produto->num_rows ){

			$this->data = $return->data[0];

			$db = Database::getInstance();
			$db->begin_transaction();

			$resVinc = $db->query( " SELECT a.id, a.valor, a.nome_vinculo as nome
									 FROM 	produto a
									 WHERE 	a.prod_vinculado = '". $this->data['id'] ."' AND 
									 		a.active = 'y' AND 
									 		( CASE WHEN a.tem_estoque = 'y' THEN a.estoque > 0 ELSE 1 END ) = 1 " );

			if( $resVinc->num_rows ){

				$dataVinc = [];
				while( $rowVinc = $resVinc->fetch_assoc() ){
					$dataVinc[] = array_map('utf8_encode', $rowVinc) ;
				}

				$this->data['bond'] = $dataVinc;

			}

			$this->msg = "";
			return true;

		} else {
			//$this->msg = $func->query;
			$this->msg = "Não existe ou não tem estoque!";
			return false;	
		}
		

	}

	function save( $request = NULL, $before = NULL, $after = NULL){
		
		$request = json_decode($request, true);
		$request['funcionario_id'] = $_SESSION['logged']['id'];

		return parent::save( $request );
	}

	
}