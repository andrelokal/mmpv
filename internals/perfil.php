
<div class="clearfix">&nbsp;</div>
<div class="panel panel-default" style="width: 600px; margin-left: auto; margin-right: auto">
  <div class="panel-heading">
    <h3 class="panel-title"> Alterar Configurações </h3>
  </div>
  
  <div class="panel-body">
    <form class='' id='perfil'></form>
  </div>
  <div class="panel-footer ">

  	<div class="">
			
		<button type="button" class="btn btn-primary submit  ">Alterar</button>

	</div>

  </div>
  
</div>


<script type="text/javascript">


	var config = new $PHP('configController');
	var formElement = $('#perfil');
	
	config.loaded = function(){
		formElement.attr('action','');	
		CallForm('forms/perfil.json', formElement, function(){

			config.call('select',[],function( ret ){
				if(ret.success){
					//console.log( config.data )
					LoadDataForm(formElement,config.data)

				}
			})

			initJs();
		}, function( ret ){

			var data = SerializeObject(formElement.serializeArray());
			config.call('save',[JSON.stringify(data)],function( ret ){
				if(ret.success){

					AlertMessage( formElement, 'success', "Sucesso!", "Registro alterado com Sucesso!", 3000 );

				} else {

					AlertMessage( formElement, 'warning', "Erro!", ret.message, 3000 );					

				}
			})
			
		})
	};
	
	

	$('.submit').click(function(){
		formElement.submit()
	})
	
	

</script>
