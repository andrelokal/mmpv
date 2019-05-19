<?php

class module extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	function __construct(){
		$this->table = 'modulo';
		$this->limit = 100;
	}

	function selectAll(){

		parent::get();
		$this->data = $this->data['grid']['data'];
		return true;

	}

	
}