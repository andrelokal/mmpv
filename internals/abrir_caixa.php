
<div class="row" style="margin-right: auto; margin-left: auto; max-width: 600px">
	<div class="col-md-6"  >
		<div class="page-header">
		  <h2><small>Abertura de Caixa</small></h2>
		</div>
		<form id='abertura-caixa' >		
          <div class="form-group" >
            <label for="valor_inicial">Valor Inicial</label>
            <input type="valor_inicial" class="form-control input-lg" name='valor_inicial' id="valor_inicial" placeholder="Valor Inicial" data-type='money'>
          </div>
          <p>
            <input type="hidden" id="step" value="1">
            <button type="submit" class="btn btn-default" id='submit'>Abrir</button>
          </p>
        </form>
	</div>
</div>


<script>
	
	$(function(){
		
		var caixa = new $PHP('caixa_ctl');              

        caixa.loaded = function(){

        	var formElement = $('#abertura-caixa');
			CallForm( null , formElement, function(){

				setTimeout(function(){$('#valor_inicial').focus()},500);

			}, function(){

				caixa.call('save',[JSON.stringify( SerializeObject(formElement.serializeArray()))],function( ret ){
		            if(ret.success){
		            	
		            	//$('.link_menu_1').click()
		            	$('#page-content').load( 'internals/sell.php', function(){
							// callback padr?
							initJs()
						})


		            } else {	             

		              	AlertMessage( formElement, 'danger', 'Atenção!', ret.message, 3000 )
		              

		            }
		        })

			})
        }

		
	})


</script>