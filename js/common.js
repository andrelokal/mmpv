var CreateFormProduct = function( id ){

	var formElement = $('#modal .modal-body form');
	formElement.attr('action','');
	CallForm('forms/produto.json', formElement, function(){

		formElement.find('#categoria_id').attr('backup','ComboCategorias');
		//Carrega categorias dos produtos
		ComboCategorias( formElement.find('#categoria_id'), function(){
			ComboUnidade( formElement.find('#unidade_id'), function(){
				if( id ){

					var produtos = new $PHP('produto_ctl');
					produtos.loaded = function(){
						produtos.call('selectById',[id],function( ret ){
							if(ret.success){
								
								LoadDataForm(formElement,produtos.data)

							}
						})
					};

				}

				initJs();
			});
		})		

		
	}, function(){

		var produtos = new $PHP('produto_ctl');
		produtos.loaded = function(){
			produtos.call('save',[JSON.stringify( SerializeObject(formElement.serializeArray())  )],function( ret ){
				if(ret.success){
					ReloadGrid()
					$('.modal-close').click();
					AlertMessage( $('#datagrid').parent(), 'success', "Sucesso", "Produto cadastrado com sucesso!", 3000 );

				}
			})
		};	

	})
}



