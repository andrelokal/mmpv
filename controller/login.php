<?php

class login extends dashboard{

	public $msg = "";
	public $data = [];
	public $page = 1;
	
	function __construct(){
		$this->table = 'funcionario';
	}

	function auth( $login, $password ){

		$func = new $this->table;
		$func	->select( 'id')
				->select( 'nome')
				->select( 'pessoa_id')
				->where( " a.login = '". $login ."' AND a.senha = '". md5($password) ."' " )
				->grid();

		$return = $func->output();
		if( $func->num_rows ){

			$_SESSION['logged'] = $return->data[0];
			$this->msg = "Aguarde você está sendo redirecionado...";
			return true;

		} else {
			//$this->msg = $func->query;
			$this->msg = "Login e/ou senha inválidos";
			return false;	
		}		

	}

	public function alterPassword($pass, $confirm, $token=NULL){

        if( !$pass ){
            $this->msg = 'Senha está vázia';
            return false;
        }

        if( $pass != $confirm ){
            $this->msg = 'Senhas não conferem';
            return false;
        }

        // Tamanho
		if( strlen( $pass ) < 6 ){				
			$this->msg = "Senha tem que conter no mínimo 6 digitos!";
			return false;
		}

		// Tem espaços em branco
		if( preg_match('/\s/',$pass) ){
			
			$this->msg = "Não pode conter espaços!";
			return false;
		}

        if( !$this->tokenValidation($token) && 
        	!$_SESSION['logged'] ){
            $data = 'token';
            $id = 1; 
            return false;
        } else {
            $id = $_SESSION['logged']['pessoa_id']; 
        }            
         
        $func = new $this->table( $id );
        if( $func->save( ["senha" => md5( $pass ) ] ) ){
            //$this->data = $response;
            $this->msg = "Senha alterada com sucesso!";
            return true;
        }else{
            $this->msg = "Erro ao alterar senha";
            return false;
        }

    }

    public function tokenValidation( $token ){
        /*if( ($this->createToken( CONF['client_id'] ) == $token) ){
            return true;
        } else {
            $this->msg = "Token Inválido!";
            return false;
        }*/
    }

    function createToken( $customer ){

        $number = date('ydmH');

        preg_match_all( '/[0-9]{2}/' , $number, $matches);

        $variador = floor(( $matches[0][3] * 2 ) / $customer);
        $password = '';
        foreach ( $matches[0] as $key => $value) {
            $password .= substr( md5($value), $variador , 1 );
        }

        $password .= substr( md5($customer), $variador ,2);

        return mb_strtoupper( $password );

    }


    function forget( $login ){

        $success = false;
        $message = '';

        if( isset( $login ) ){

            $con = Database::getInstance();
            $con->begin_transaction();

            $query = sprintf(   "   SELECT  A.login, A.senha, B.email, B.id
                                    FROM    funcionario A JOIN 
                                            pessoa B ON A.pessoa_id = B.id
                                    WHERE   login ='%s' OR B.email = '%s'  ", 
                                $con->real_escape_string( $login ),
                                $con->real_escape_string( $login ) );
            $res = $con->query( $query );
            if( $res->num_rows ){

                $row = $res->fetch_assoc();
                
                $token = $this->token_new_password();
                
                $update = sprintf(  "UPDATE funcionario      
                                     SET token_change_password = '%s'
                                     WHERE id =%d ", 
                                     $con->real_escape_string( $token ),
                                     $con->real_escape_string( $row['id'] ) );
                if( $con->query( $update ) ){

                    $Email      = $row['email'];
                    //Enviar Email
                    $assunto    = ' Esqueceu sua senha ';
                    $mens       = ' Voc&ecirc; solicitou uma nova senha de acesso para seu cadastro!<br> ';
                    $mens       .= " Clique aqui : <a href='http://". $_SERVER['HTTP_HOST'] ."/change-password/?token=".$token."'>".$token."</a>";

                    $erro = $this->sendmail( $assunto ,
                                             $mens,
                                             $Email,
                                             $Email);

                    if(is_array($erro)){
            
                        $message = $erro[0];
                        //$msg = 'Erro ao enviar e-mail!';
                        $con->rollback();
                        
                    }else{
                        $message = 'Você receberá um e-mail com instruções!';
                        $success = true;
                        $con->commit();
                    }

                } else {

                    $message = 'Erro ao criar token!';

                }

            } else {
                $message = 'Email não registrado em nossa base';

            }

            $this->msg = $message;
            return $success;

        }
    }

    function token_new_password( $c = 3, $n = 2, $s = 1 ){

        $chars = 'qwertyuiopasdfghjklzxcvbnm';
        $number = '1234567890';     
        $symbol = ',.;/~]´[-=09*&¨%$#@!ç';

        $pass = array();
        
        $c_ar = str_split($chars);
        for( $i = 0; $i < $c; $i ++ ){
            shuffle( $c_ar );
            $pass[] = $c_ar[0];
        }

        $n_ar = str_split($number);
        for( $i = 0; $i < $n; $i ++ ){
            shuffle( $n_ar );
            $pass[] = $n_ar[0];
        }

        $s_ar = str_split($symbol);
        for( $i = 0; $i < $s; $i ++ ){
            shuffle( $s_ar );
            $pass[] = $s_ar[0];
        }

        return md5(implode('', $pass));

    }

    public function sendmail(   $subject,
                                $body,
                                $to,
                                $name,
                                $Bcc=false,
                                $reply=false,
                                $email_fromName=false,
                                $anexos = false){
                                    

        $config = $this->getConfig();

        //Variavel
        $email_from     = $config['email']['email'];
        $email_pass     = $config['email']['password'];
        $email_server   = $config['email']['server'];
        $email_port     = 587;
        $email_secure   = NULL;
        $email_debug    = NULL;
        $email_fromName = '';       

        if(empty($reply)){
            $reply = $email_from;
        }

        ob_start();
        $mail = new phpmailer;
    
        $mail->IsSMTP();
        $mail->Host = $email_server;
        $mail->Port = $email_port;
        $mail->SMTPAuth = true;
        $mail->Username = $email_from;
        $mail->Password = $email_pass;
        $mail->SMTPSecure = $email_secure;
        $mail->SMTPDebug = $email_debug;
    
        $erro = false;
    
        $mail->From         = $email_from;
        $mail->FromName     = $email_fromName;      
        $mail->AddReplyTo($reply,$email_fromName);
    
        $mail->AddAddress($to,$name);
        
        if($anexos){
            for($a=0;$a<count($anexos);$a++){
                $mail->AddAttachment($anexos[$a]);
            }
        }
    
        if($Bcc && $x==0){
            $mail->AddBcc($Bcc);
        }
    
        $mail->WordWrap = 50;       
        $mail->IsHTML(true);
    
        $mail->Subject  =  $subject;
        $mail->Body     =  $body;               
        $ok = $mail->Send();
            
        if(!$ok){
            $erro[] = $mail->ErrorInfo;
        } 
    
        $mail->ClearAllRecipients();    
            
        ob_clean();
        
        
        return $erro;

    }


    function change_password( $new_pass, $new_pass_repeat, $token ){

        $func = new $this->table;

        $ret =  $func->change_pass( $table = "funcionario",
                                    $colums = [ "id"          => "id",
                                                "login"       => "login",
                                                "token"       => "token_change_password",
                                                "password"    => "senha" ],
                                    $post = [   "password" => $new_pass, 
                                                "password-repeat" => $new_pass_repeat,
                                                "token" => $token ] );

        $this->msg = $ret['message'];
        return $ret['success'];

    }


	

	
}