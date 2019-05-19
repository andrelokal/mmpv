var MesaActive = false;

function MostraMesas(){
	MesaActive = false;
	mesas = new $PHP('table_ctl');
	mesas.loaded = function(){
		mesas.call('selectAll',[], function( ret ){
			$("#mesas").html("<div class='panel panel-default'>"+
								"<div class='panel-heading'>Mesas / Comandas </div>"+
								"<div class='panel-body'>"+
								"</div>"+
							 "</div>");

			var empty = "default";
			var mesa_selected = null;
			var selected = "default";

			for( var i in mesas.data.itens ){

				var item = mesas.data.itens[i];
				
				var status = item.status;
				switch( status ){
					case "L" : // livre
						selected = "success";
						break;
					case "O" : // Ocupada
						selected = "info";
						break;
					case "P" : // Em Pagamento
						selected = "danger";
						break;

				}

				if( item.id == mesas.data.selected ){
					selected = "primary" ;
					mesa_selected = item;	
				}
				

				var button = 	"<button  class='item_mesa btn btn-"+selected+" btn-xs' value='"+ item.id +"' >"+
								item.codigo+
								"</button> ";
				$("#mesas .panel .panel-body").append( button )
			}

			if( mesa_selected ){
				MesaActive = true;

				$(".line-mesa-actived").find(".mesa-codigo").html( mesa_selected.codigo )
				$(".line-mesa-actived").find(".mesa-status").html( mesa_selected.status_text )
				$(".line-mesa-actived").find(".mesa-dt_status_O").html( ( mesa_selected.dt_status_O ? mesa_selected.dt_status_O : " -- " ) )
				$(".line-mesa-actived").show();
			} else {
				$(".line-mesa-actived").hide();
			}

			var button = "<button  class=' btn btn-"+empty+" btn-xs exit-mesa' value='' > x </button> ";
			$("#mesas .panel .panel-body").append( button );

			$(".btn.item_mesa").unbind('click').click(function(){

				var id = $(this).val();
				if( !mesa_selected && ItensVenda.length ){
					AlertMessage( $('#page-content'), 'warning', "Atenção", "Itens não registrados estão no pedido!", 3000 );
					return false;
				}
				SetMesa( id )			
				return false;

			})

			$('.exit-mesa').unbind('click').click(function(){
				SairMesa( mesas )					
				return false;
			})

			$('.pay-mesa').unbind('click').click(function(){
				
				mesas.call('PagarMesa',[null], function( ret ){
					if(ret.success){
						MostraMesas()	
						LimparTelaVenda()						
					}
				})

				return false;
			})

			$('.destroy-mesa').unbind('click').click(function(){
				
				LiberarMesa()
				return false;
			})

			$('.save-item-mesa').unbind('click').click(function(){

				var itens = ItensToSend();

				if( !itens.length ){
					//AlertMessage( $('#datagrid').parent(), 'warning', "Atenção", "Nenhum item na venda!", 3000 );
					//return false;
				}

				var request = {	"itens"	: itens }

				venda.call('save',[JSON.stringify( request )],function( ret ){

					if(ret.success){
						AlertMessage( $('#page-content'), 'success', "Sucesso", "Itens enviados com sucesso!", 3000 );
						SetMesa( ret.data.result.mesa_id )
					} else {
						AlertMessage( $('#page-content') , 'warning', "Atenção! ", ret.message, 3000 );
					}

				});

				return false;
			})
		})
	}
}

function SetMesa( id ){

	mesas = new $PHP('table_ctl');
	mesas.loaded = function(){		
		mesas.call('setMesa',[id], function( ret ){
			if(ret.success){
				LimparTelaVenda()
				MostraMesas()
				if( ret.data.result.length ){
					ItensVenda = '';
					ItensVenda = [];
					var data = ret.data.result;
					for( var i in data ){
						// Nova linha Pedido
						var newline = {	name: data[i].nome,
										item_value : Number(data[i].valor_unitario),					
										amount : Number(data[i].quantidade),
										value : CalculateAmount( data[i].quantidade , data[i].valor_unitario ),
										mode : '1',
										id: data[i].id,
										status : data[i].status,
										item_id : data[i].item_id,
										descricao : "" };
						// Adiciona nova linha
						ItensVenda.push( newline );	
					}
					// Adiciona nova linha ao storage
					localStorage.setItem( 'ItensVenda', JSON.stringify(ItensVenda) );
					LoadItensVenda( )
				}
			}
		})
	}
	
}

function LimpaDadosMesas(){
	$(".line-mesa-actived").hide();
	$(".item_mesa.btn-primary").removeClass( 'btn-primary' ).addClass('btn-success')
}

function SairMesa( mesasPHPjs, confirmed ){

	if( ItensVenda.length ){
		if( !confirmed ){
			
			ModalConfirm( "Atenção", "Itens não gravados! Deseja sair mesmo assim ?", function(){
				SairMesa( mesasPHPjs, true );
			})

			return false;
		} 
	}	

	mesas.call('setMesa',[null], function( ret ){
		if(ret.success){
			MostraMesas()	
			LimparTelaVenda()						
		}
	})
}

function LiberarMesa(){
	if( ItensVenda.length ){
		AlertMessage( $('#datagrid').parent(), 'warning', "Atenção", "Pague e/ou cancele os itens para liberar a mesa ?", 5000 );
		return false;
	}	

	if( !confirm('Tem certeza que deseja continuar ?') ) {
		return false;
	}

	mesas.call('destroyMesa',[], function( ret ){
		if(ret.success){
			MostraMesas()	
			LimparTelaVenda()
		}
	})	
}

function CancelItem( item_id, callback ){
	var mesas = new $PHP('table_ctl');
	mesas.loaded = function(){
		mesas.call('cancelItem',[item_id], function( ret ){
			if( ret.success ){
				SetMesa( ret.data.result.mesa_id )
			}
		})
	}
}