<?php

class fpagto_ctl extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	function __construct(){
		$this->table = 'forma_pagto';
	}

	function selectAll( $offset = "",$rows = "", $active="" ){

		$where = "";
		if( $active == 'v' )	$where = " active='y' ";
 		if( $active == 'c' )	$where = " active_c='y' ";

		$table = new $this->table();
		$table	->select( '*')
				->where( $where )
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

	function save( $request = NULL, $before = NULL, $after = NULL){
		/*
		$request = json_decode($request, true);
		$request['funcionario_id'] = $_SESSION['logged']['id'];

		return parent::save( $request );
		*/
	}

	
}