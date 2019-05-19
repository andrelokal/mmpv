<h1>Ajuda <small>manual do usuário</small></h1>
<div class="row" >

	<div class="col-md-3">
		
		  	<ul class="list-group help" >
			<?php

				$help = new Help();
				$result = $help->selectAll();
				foreach( $result as $row ){
					?>
						
						    <li class="list-group-item">
							    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#<?=$row->id?>" aria-expanded="true" aria-controls="<?=$row->id?>" class="ahref collapsed">
						          <?=$row->title?>
						        </a>
					        </li>
						    
						      <?php
						      	$itens = $help->getItens($row->id);
						      	  if( count($itens) ){
						      	  	?>
						      	  	<ul id="<?=$row->id?>" class="panel-collapse collapse in list-group help"  >
						      	  	<?php
						      	  	foreach ($itens as $rowItem) {
							      	  	?>
							      	 		<button class="list-group-item sub" type="button" >
							      	 		<a href='/internals/page.php?id=<?=$rowItem->id?>' target='#page-content-help'><?=$rowItem->title_item?></a>
							      	 		</button>
							      	 	<?php
							      	}
							      	?>
						      	  	</ul>		
						      	  	<?php	
						      	}			      	  

					      	  ?>
						    			
					<?php
				}

			?>
			</ul>


	</div>
	<div class="col-md-9" id='page-content-help'>
		
	</div>
	
</div>


<script type="text/javascript">


	$('.collapse').collapse()

	/*var config = new $PHP('configController');
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
	})*/
	
	

</script>
