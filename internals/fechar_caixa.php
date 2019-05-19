<form id='fechamento-caixa' >
	<div class="row">
		<div class="col-md-5">
			<div class="form-group " >
		    	<label for="valor_inicial">Dinheiro no Caixa</label>
		    	<input type="valor_inicial" class="form-control input-lg " name='valor_fechamento' id="valor_fechamento" placeholder="Valor Fechamento" data-type='money'>
		  	</div>
		</div>
		<div class="col-md-7">
			<div class="form-group " >
		    	<label for="valor_inicial">Totais por Forma </label>
		  		<div class="free totais">
		  			
		  		</div>
		  	</div>
		</div>
	</div>	
</form>
<div id="navbarForm" class="navbar-collapse collapse">
	<ul class="nav navbar-nav navbar-right help">
	  <li >
	      <kbd>Esc</kbd> Fechar Janela
	  </li>
	</ul>
</div><!--/.nav-collapse -->
<script>
	$(function(){
		
		var caixa = new $PHP('caixa_ctl');              
		var valor_fechamento = 0;

        caixa.loaded = function(){

        	var formElement = $('#fechamento-caixa');
			CallForm( null , formElement, function(){

				caixa.call('valorEmCaixa',[],function( ret ){
		            if(ret.success){
		            	
		            	var soma_din = Number(caixa.data.soma) + Number(caixa.data.init);
		            	$('.free.totais').html("");
		            	for( var i in caixa.data.detail ){
		            		var div = $("<div>");
		            		div.html( "+ "+caixa.data.detail[i].nome +" : <B>"+ MoneyFormat( caixa.data.detail[i].soma )+"</B>" );
		            		$('.free.totais').append( div )
		            	}

		            	$('.free.totais').append( "<hr></hr>" );
		            	$('.free.totais').append( "<div>Total : <b>"+ MoneyFormat(caixa.data.soma) +"</b></div>" );
		            	$('.free.totais').append( "<div>- Valor Inicial: <b>"+ MoneyFormat(caixa.data.init) +"</b></div>" );
		            	$('.free.totais').append( "<div>Valor total Caixa : <b>"+ MoneyFormat(caixa.data.caixa) +"</b></div>" );		            	
		            	$('.free.totais').append( "<div>Valor Din. Caixa : <kbd>"+ MoneyFormat(caixa.data.caixa_din) +"</kbd></div>" );	
		            	valor_fechamento = caixa.data.caixa_din;	            	

		            }
		        })

			}, function(){
				if( valor_fechamento.toFixed(2) != Number($('#valor_fechamento').val()) ){
					if( !confirm('Valor não confere, deseja continuar ?') ) return false;
				}

				caixa.call('save',[JSON.stringify( SerializeObject(formElement.serializeArray()))],function( ret ){
		            if(ret.success){
		            	
		            	$('.modal-close').click();
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