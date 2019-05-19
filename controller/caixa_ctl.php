<?php

class caixa_ctl extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	function __construct(){
		$this->table = 'caixa';
	}

	function check_caixa_aberto(){

		$caxa = new $this->table();
		$caxa->limit = 1;
		$response = $caxa->sqlExec(" SELECT * 
									 FROM 	". $this->table ." 
									 WHERE 	funcionario_id = '".$_SESSION['logged']['id']."' AND 
                                            dt_fechamento IS NULL 
                                            LIMIT 1 ");

        if($response->result->num_rows){
            
        	$row = $response->result->fetch_assoc();
        	$this->data = $row;
            return true;

        }else{
            
            $this->msg = "Nenhum caixa aberto!";
            return false;

        }
		

	}

	function save( $request = NULL, $before = NULL, $after = NULL){
		
		$request = json_decode($request, true);

		if( array_key_exists('valor_fechamento', $request) ){
			$this->check_caixa_aberto();
            $request['id'] = $this->data['id'];
            $request['dt_fechamento'] = date('d/m/Y H:i:s');
		}

		$request['funcionario_id'] = $_SESSION['logged']['id'];

		return parent::save( $request );
	}

	function valorEmCaixa(){
            
        $ret = $this->check_caixa_aberto();
        if( $ret === false ){
            return false;
        }

        $id = $this->data['id'];
        $vlr_inicial = $this->data['valor_inicial'];

        $caxa = new $this->table();
		$response = $caxa->sqlExec("SELECT  X.nome, 
											A.forma_pagto_id, 
											SUM(A.valor) AS soma
									FROM 	venda_pagto A LEFT JOIN 
											forma_pagto X ON A.forma_pagto_id = X.id LEFT JOIN
											venda 		B ON A.venda_id = B.id LEFT JOIN
											fisica_conta C ON A.fisica_conta_id = C.id 
									WHERE 	B.caixa_id = '".$id."' OR C.caixa_id = '".$id."' AND
											B.status != 'C'
									GROUP BY forma_pagto_id 
									ORDER BY forma_pagto_id  ");

        if($response->result->num_rows){

        	$total = 0;
        	$total_din = 0;
        	while( $row = $response->result->fetch_assoc() ){
        		$details[] = $row;
        		$total += (float) $row['soma'];
        		if( $row['forma_pagto_id'] == 1 ){
        			$total_din += (float) $row['soma'];
        		}
        		
        	}
          	
            
            $this->data = (object) ['soma'=> $total, 
            						'init' => $vlr_inicial,
            						'caixa' => ($total - $vlr_inicial),
            						'detail' => $details,
            						'caixa_din' => $total_din - $vlr_inicial ];

            $this->msg = "Sucesso";
            return true;

        }else{
            
            $this->msg = "Sem Resultados";
            return false;

        }

    }


	
}