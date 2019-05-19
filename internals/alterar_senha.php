<div class="row" style="margin-right: auto; margin-left: auto; max-width: 400px" >

	<div class="col-md-12"  >
		<div class="page-header">
		  <h2><small>Alterarção de Senha</small></h2>
		</div>
		<form id='form-alterar-senha' style="">
		
          <div class="form-group new-pass" >
            <label for="password">Nova senha</label>
            <input type="password" class="form-control" name='password' id="password" placeholder="Nova senha">
          </div>
          <div class="form-group new-pass" >
            <label for="password-confirm">Confirmar nova senha</label>
            <input type="password" class="form-control" name='password-confirm' id="password-confirm" placeholder="Confirmar nova senha" >
          </div>
          <p>
            <input type="hidden" id="step" value="1">
            <button type="submit" class="btn btn-default" id='submit'>Alterar</button>
          </p>
        </form>
 	</div>
  	
</div>


<script>
	
	$(function(){
		$('.responsive-h').responsive({padding:[0,0,300,0]});

		var login = new $PHP('login');              

        login.loaded = function(){

        	var formElement = $('#form-alterar-senha');
			CallForm( null , formElement, function(){



			}, function(){

				login.call('alterPassword',[$('#password').val(),$('#password-confirm').val()],function( ret ){
		            if(ret.success){
		            	$('#password').val('');
		            	$('#password-confirm').val('');
		                AlertMessage( formElement, 'success', 'Sucesso!', ret.message, 5000 ); 

		            } else {	             

		              	AlertMessage( formElement, 'danger', 'Atenção!', ret.message, 3000 )
		              

		            }
		        })

			})
        }

		
	})


</script>