<?php
	
	include('../mmpv/controller/caixa_ctl.php');
	$caixa = new caixa_ctl;	
	if ( !$caixa->check_caixa_aberto() ){
		header("Location: abrir_caixa.php");
	}

?>
<div class="row">
	<div class="col-md-9">
		<div class="input-group input-group-lg">
	      	<input type="text" class="form-control active" placeholder="Digite o código ou Cod. Barra" id='produto'>
      		<span class="input-group-btn">
	        	<button class="btn btn-success add" type="button">Adicionar</button>	        	
	        	<!-- <button class="btn btn-default help" type="button" data-help="10" placement="bottom"><span class="glyphicon glyphicon-question-sign"></span></button> -->
	      	</span>	      	
	   	</div>

	</div>
	<div class="col-md-3">
		<div class="input-group input-group-lg">
	      	<input type="text" class="form-control" id='pesquisar-produto' placeholder="Pesquisar...">
      		<span class="input-group-btn">
	        	<button class="btn btn-primary" type="button"><span class="glyphicon glyphicon-search"></span></button>
	        	<!-- <button class="btn btn-default help" type="button" data-help="15" placement="left"><span class="glyphicon glyphicon-question-sign"></span></button> -->
	      	</span>
	   	</div><!-- /input-group -->		
	</div>
</div>
<div class="clearfix">&nbsp;</div>
<div class="row" id='content'>
	<div class="col-md-9">
		<div id='displayPizza' class="row"></div>
		<div class="row line-mesa-actived " style="display: none" >
			<div class="col-md-12 container-fluid">
				<p class="text-primary ">
					Mesa: <kbd class='mesa-codigo'></kbd> | 
					Status: <kbd class="mesa-status"></kbd> | 
					Atendimento: <kbd class="mesa-dt_status_O"></kbd> | 
					<button type="button" class="btn btn-xs btn-info save-item-mesa"> Enviar Itens </button> 
					<button type="button" class="btn btn-xs btn-danger exit-mesa"> Sair </button> 
					<button type="button" class="btn btn-xs btn-warning destroy-mesa"> Liberar </button>
					<button type="button" class="btn btn-xs btn-success pay-mesa"> Pagar </button>
				</p>
			</div>
		</div>
		<div class="clearfix">&nbsp;</div>
 		<table class="table table-hover table-bordered display" id='datagrid' ></table>
  	</div>
  	<div class="col-md-3">
  		
  		<ul class="list-group ">
			<li href="#" class="list-group-item list-group-item-warning">
			    <p class="text-center">
					<h1 id='totalitens' class="text-center">R$ 0,00</h1>
				</p>
		  	</li>
		  	<li class="list-group-item">
		  		<p class="text-center">
		  			<button type="button" class="btn btn-success  pagamento">Pagar Agora</button>
				</p>		  		
		  	</li>
		  	<!-- 
		  	
		  	-->
		</ul>
		<div id='mesas'></div>
  	</div>
</div>

<script type="text/javascript">

	var payment = false;
	var produtos = null;
	var venda = null;

	$(function(){

		var pizzaStorage = JSON.parse(localStorage.getItem('pizza'));
		if( pizzaStorage ) ShowPizzaDisplay();

		$('.btn.add').click(function(){
			ProdutoPorCodigo( $('#produto').val() );
		});

		InitTelaVenda();

		salling = true;
		$('.btn.pagamento').click(function(){
			EfetuarPagamento();
		});

		$('.btn.fiado').click(function(){
			EfetuarPagamento();
		});

		// confere se tem caixa aberto
		produtos = new $PHP('produto_ctl');
		venda = new $PHP('sale_ctl');
		fisicaConta = new $PHP('buyer_ctl_account');		

		Keyboard_step = 'sell';
		Payment_step = 'pay_discount';
		MostraMesas();
	})

	function ItensToSend(){
		var itens = [];
		for( var i in ItensVenda ){

			if( ItensVenda[i].status == "A" ||
				ItensVenda[i].status == "C" ||
				ItensVenda[i].status == "X" ){
				continue;
			}

			itens.push({	"produto_id"	 : ItensVenda[i].id ,
							"quantidade"	 : ItensVenda[i].amount ,
							"valor_item" 	 : ItensVenda[i].item_value,
							"status"		 : ItensVenda[i].status,
							"descricao"		 : ItensVenda[i].descricao
						})
		}

		return itens;
	}


	// Depois que carerga a tela de Venda
	function InitTelaVenda(){

		LoadItensVenda( true );
		
		$('#produto').focus(function(){
			$(this).addClass('active');
			Keyboard_step = 'sell';
		}).focus();

		$('#produto').blur(function(){
			$(this).removeClass('active')
		});
	}

	// Procura Produto por Codigo
	function ProdutoPorCodigo( vlr ){

		if( vlr ){
				
			produtos.call('selectBycode',[vlr],function( ret ){

				if( ret.success ){
					
					Keyboard_step = 'quantidade';

					$('#produto').val('');
					var data = produtos.data
					var unidade_id = data.unidade_id;
					var estoque_min = Number(data.estoque_min);
					var estoque = Number(data.estoque);
					if( estoque <= estoque_min && data.tem_estoque == 'y' ){
						Notify( "Produto com pouco estoque!!", "warning" )
					}	

					$('#modal').data('keyboard',false);

					Modal( 'Quantidade', 'internals/form.php', function(){					

						var formElement = $('#modal .modal-body form');

						CallForm('forms/quantidade.json', formElement, function(){

							if( data.bond ){
								var df = $('<div>')
								//df.addClass('df-group').addClass('bond');
								
								var fg = $('<div>');
								//fg.addClass('form-group');

								var ul = $("<ul class='nav nav-pills nav-justified navbar-left bond'>")
								var item = 	"<li role='presentation'>"+
											"<input type='radio' name='bond' checked=checked value='"+ data.id +"' price='"+ data.valor +"' title='"+ data.nome +"'> Padrão "+
											"</li>";

								ul.append( item )	
								for( var b in data.bond ){
									var item = 	"<li role='presentation'>"+
												"<input type='radio' name='bond' value='"+ data.bond[b].id +"' price='"+ data.bond[b].valor +"' title='"+ data.bond[b].nome +"'> "+ data.bond[b].nome +"  "+
												"</li>";

									ul.append( item )
								}

								fg.append( ul )	
								df.append( fg )
								formElement.prepend(df);
								$('.nav.bond li input').unbind('focus').focus(function(){
									formElement.find('#id').val( $(this).val() );
									formElement.find('#valor').val( $(this).attr('price') );
									formElement.find('.main option').removeAttr('selected')
									formElement.find('.main option:eq(0)').prop('selected','selected')
									formElement.find('.main').change()
								})
								
							}							

							initJs();

							formElement.removeClass('thre-columns').addClass('two-columns');

							LoadDataForm(formElement,data)

							// define campo valor do item igual o valor unitario do produto
							formElement.find('#valoritem').val( formElement.find('#valor').val() )
							formElement.find('#quantidade').prop('autocomplete','off').addClass('main');

							switch( Number(unidade_id) ){
								case 1: // Unidade
										// Focu da quantidade
										setTimeout(function(){
											// Seleciona o campo quantidade
											formElement.find('#quantidade').selectRange(0,10);
											// ao sair do campo...
											formElement.find('#quantidade').unbind('blur').blur( function(){
												// Seleciona o campo quantidade
												formElement.find('#quantidade').selectRange(0,10);
											}).blur();

										},500)
										
										// Ao presscionar algum valor no campo quantidade
										formElement.find('#quantidade').keypress(function( e ){
											
											switch( e.which ){
												// ENTER
												case 13:
														AdicionaItemVenda();
														return false;
													break;

												// MAIS
												case 43:
														
														$(this).val( Number( $(this).val() ) + 1 )
														return false;

													break;									

												// MENOS
												case 45:
														
														$(this).val( Number( $(this).val() ) - 1 )
														return false;

													break;

											}

										}).keyup(function(){

											// Ao soltar a tecla
											// Se o campo for 0 deixa 1
											if( $(this).val() == 0 ) $(this).val(1);

											clearInterval(interval);
											interval = setInterval(function(){
												
												// Calcula o valor da quantidade x o valor
												CalculateAmountItem()
												// Seleciona o campo quantidade
												formElement.find('#quantidade').selectRange(0,10);

											},500);
										})
									break;

								case 2: // Livre

										formElement.find('#quantidade').attr('disabled','disabled');
										formElement.find('#valoritem').removeAttr('disabled').removeAttr('readonly').val('');
										/*setTimeout(function(){
											formElement.find('#valoritem').focus();
										},500)*/

									break;

								case 4: // Fração

										formElement.find('#quantidade').parent().find('select').remove()
										formElement.find('#quantidade').hide();

										
										var select = $("<select class='form-control input-lg' id='forma_fracao' ></select>");
										select.append("<option value='1'>Inteiro(a)</option>");
										select.append("<option value='0.5'>1/2</option>");
										select.append("<option value='0.25'>1/4</option>");
										select.append("<option value='0.125'>1/8</option>");

										formElement.find('#quantidade').after( select );
										$('#forma_fracao').unbind('change').change(function(){

											formElement.find('#quantidade').val( $(this).val() )
											CalculateAmountItem();

										}).change()
										$('#forma_fracao').addClass('main')									

									break;

								default: // Kg, Ml, Mt

										formElement.find('#quantidade').twovalues({
										input_1 : { symbol: 'Kg', 
													label: 'Porcentagem', 
													class : 'input-lg focus-select-range',  
													keydown: function( e ){
														if( e.which == 32 ){													

															$(this).parents('.twov:eq(0)')
															.hide()
															.removeClass('active')
															.next()
															.addClass('active')
															.show()
															.find('input')
															//.focus()

															return false;
														}
													},
													keyup: function( e ){
														formElement.find('#quantidade').val( $(this).val() )
														CalculateAmountItem()

														$(this).parents('.twov:eq(0)')
														.next()
														.find('input')
														.val( formElement.find('#valoritem').val() )
														
														$(this).parents('.form-group:eq(0)')
														.find('.help-block')
														.html( MoneyFormat( formElement.find('#valoritem').val() ) )

													}, 
													active : 'active',
													type : "" },
										input_2 : { symbol: '$', 
													label: 'Monetário', 
													class : 'input-lg focus-select-range', 
													keydown: function( e ){
														if( e.which == 32 ){														
																
															$(this).parents('.twov:eq(0)')
															.hide()
															.removeClass('active')
															.prev()
															.addClass('active')
															.show()
															.find('input')
															//.focus()

															return false;
														}
													},
													keyup: function( e ){
														formElement.find('#quantidade').val( ConvertValorParaPeso( $(this).val() ) )

														$(this).parents('.form-group:eq(0)')
														.find('.help-block')
														.html( Number(formElement.find('#quantidade').val()).toFixed(3)+" Kg"  );

														$(this).parents('.twov:eq(0)')
														.prev()
														.find('input')
														.val( Number(formElement.find('#quantidade').val()).toFixed(3) )

														CalculateAmountItem()

													},
													type : "money" }
									})

									InitInputs()

									setTimeout(function(){
										formElement.find('.form-group.quantidade .twov_field_1 input').decimal(3)
										//formElement.find('.form-group.quantidade .twov_field_1 input').focus();									
									},500);

									break;
							}
							setTimeout(function(){
								SetFocusEnabled( formElement, 0 );
								//$('#forma_fracao').focus()
							},500)

						}, function(){
							AdicionaItemVenda();
						});
					}, 'md')	
				} else {
					AlertMessage( $('#datagrid').parent(), 'warning', 'Desculpe!', ret.message, 3000 )
					//alert( ret.message )
				}			
			})
		}	
	}

	function SetFocusEnabled( form, eq ){
		form.find('input[readonly!=readonly]:visible,select[readonly!=readonly]:visible').eq(eq).focus();
	}

	function LoadItensVenda( keyEvent ){

		if( ItensVenda ){

			// Carrega itens do pedido
			DataTable = $('#datagrid').DataTable({
				ordering : false,
		        scroller: true,
	        	paging:  false,
	        	searching: false,
				data: ItensVenda ,
				rowId: 'id',
				rowCallback: function( row, data, index ) {
					for( var i in data  ){
						$(row).attr( i , data[i] )	
					}				    
				},
		        columns: [
		            /*{ title: "ID", width: "10%" },*/
		            { title: "Produto", width: "50%", data : "name" },
		            { title: "Qnt.", width: "5%", data : "amount",
		            	render : function( data, type, full, meta ){

		            		var value = data;

	            			if( full.mode == 4 ){
	            				value = ConverteFracao( value );
	            			} 

		            		return value;
		            	} 
		            },
		            {
		                title : "Valor Item",
		                width: "10%",
		                "render": function ( data, type, full, meta ) {

		                	return MoneyFormat(full.item_value.toFixed(2));
		                }
		            },
		            {
		                title : "Valor",
		                width: "10%",
		                "render": function ( data, type, full, meta ) {

		                	return "<b>"+MoneyFormat(full.value.toFixed(2))+"</b>";
		                }
		            },
		            {
		                title : "Status",
		                width: "5%",
		                "render": function ( data, type, full, meta ) {

		                	var status = full.status;

		                	var i = "";
		                	switch( status ){

		                		case 'A' :
		                			i = "repeat"; // Andamento
		                			break;

		                		case 'C' :
		                			i = "ok"; // Concluido
		                			break;

		                		case 'X' :
		                			i = "ban-circle"; // Cancelado
		                			break;

		                		case 'E':
		                			i = "send"; // Enviado
		                			break; 

		                		default :
		                			i = "hourglass"; // Enviado
		                	}


		                	var icon = "<i class='glyphicon glyphicon-"+ i +"' ></i> ";


		                	return icon;
		                }
		            }
		        ],
		        destroy: true
		    });
		} 

		initKeyTable()
		TotalItens();
	}

	function TotalItens(){

		$('#totalitens').html( MoneyFormat( TotalVenda() ) )	
		
	}

	function TotalVenda(){

		var total = 0;	
		if( ItensVenda && ItensVenda.length ){
			for( var i in ItensVenda ){
				if( ItensVenda[i].status != 'X' )  total += Number( ItensVenda[i].value );
			}	
		}

		return total.toFixed(2);

		
	}

	// Calculos

	function CalculateAmountItem(){

		// Calcula a quantidade x valor para item
		var formElement = $('#modal .modal-body form');
		var valor = Number(formElement.find('#valor').val())
		var quantidade = Number(formElement.find('#quantidade').val())
		formElement.find('#valoritem').val( MoneyFormat( CalculateAmount( quantidade, valor ) , '', ".")  );
		clearInterval(interval);

	}

	function CalculateAmount( qnt, vlr ){
		return qnt * vlr;
	}

	// Adiciona item na tela de venda para envio posterior 
	function AdicionaItemVenda(){
		
		// identifica form Element
		var formElement = $('#modal .modal-body form');

		var id = formElement.find('#id').val();
		if( !id ) return false;
		var codigo = formElement.find('#codigo').val();
		var nome = "("+codigo+") "+formElement.find('#nome').val();

		if( formElement.find("[name=bond]").length ){
			nome += " / "+formElement.find("[name=bond]:checked").attr('title')
		}

		var valor = Number(formElement.find('#valor').val());
		var unidade = formElement.find('#unidade_id').val();
		var valoritem = Number(formElement.find('#valoritem').val());
		var qnt = formElement.find('#quantidade').val();
		if( Number(unidade) > 2 ) qnt = Number(qnt).toFixed(3)
		var categoria_id = formElement.find('#categoria_id').val();

		// Pizza
		if( categoria_id == 4 ){
			if( !StartPizza( id, qnt, valoritem, nome ) ){
				return false;
			}
 		}

		var newLine = true;
		if( unidade == '1' ){
			newLine = AdicionaRemoveItem( id, qnt);
		}

		if( unidade == '2' ){
			valor = valoritem;
		}

		// Nova linha
		if( newLine ){
			// Nova linha Pedido
			var newline = {	name: nome,
							item_value : valor,					
							amount : qnt,
							value : CalculateAmount( qnt , valor ),
							mode : unidade,
							id: id,
							status : "",
							item_id : '',
							descricao : "" };

			// Adiciona nova linha
			ItensVenda.push( newline );	
			// Adiciona nova linha ao datatable
			DataTable.row.add( newline ).draw( false );

		} 

		// Adiciona nova linha ao storage
		localStorage.setItem( 'ItensVenda', JSON.stringify(ItensVenda) );

		// Recarrega o tabela
		LoadItensVenda()
		
		// fecha o modal
		$('.modal-close').click();
	}

	function AdicionaRemoveItem( id, qnt, tr, confirmed ){

		var newLine = true;
		// procura se o produto j?est?adicionados aos itens
		if( MesaActive && qnt > 0 ) return true;		

		var tr = $('#datagrid tr.selected');
		var item_id = tr.attr('item_id');
		var amount = tr.attr('amount');
		
		if( item_id ){
			if( !confirmed ){
					
				ModalConfirm( "Atenção", "Deseja realmente apagar este item ?", function(){
					CancelItem( item_id);
				})

				return false;
			} 			
		}

		var q = 0;
		// Varre os itens
		for( var i in ItensVenda ){

			if( item_id ){

				if( ItensVenda[i].item_id == item_id ){
					ItensVenda.splice(i, 1);					
					newLine = false;
					break;
				}

				//newLine = false;
			} else {
				if( ItensVenda[i].id == id && ItensVenda[i].amount == amount ){

					q = Number( ItensVenda[i].amount );
					ItensVenda[i].amount = q + Number(qnt);

					if( Number(ItensVenda[i].amount) <= 0 ){

						ItensVenda.splice(i, 1);

					} else{

						// Calcula Item por quantidade
						ItensVenda[i].value = CalculateAmount( Number( ItensVenda[i].item_value ), Number( ItensVenda[i].amount) );

					}			

					newLine = false;
					break;
				} 	
			}
			
		}

		if( !newLine ){
			// Adiciona nova linha ao storage
			localStorage.setItem( 'ItensVenda', JSON.stringify(ItensVenda) );
		} 

		//$('#datagrid').keytable("TopDown"); 
		
		return newLine;

	}

	function StartPizza( id, qnt, value, name ){

		if( Number(qnt) < 1 ){

			var pizzaStorage = JSON.parse(localStorage.getItem('pizza'));
			if( !pizzaStorage ) pizzaStorage = [];

			var pc = PizzaCalculate( qnt );
			if( pc.size > 1 ){
				AlertMessage( $('#displayPizza'), "warning", "Oow!", "Pizza maior que o normal", 3000 );
				$('.modal-close').click();
				return false;
			}

			compl = ( pc.size == 1 )

			pizzaStorage.push({ id: id,
								qnt : qnt,
								value : value,
								name : name });

			localStorage.setItem( 'pizza', JSON.stringify(pizzaStorage) );
			
			ShowPizzaDisplay()

			$('.modal-close').click();
			return false;
		} else {
			return true;
		}

	}

	function PizzaCalculate( qnt ){
		var pizzaStorage = JSON.parse(localStorage.getItem('pizza'));
		if( !pizzaStorage ) pizzaStorage = [];
		var total = 0;
		var sabor = [];
		var valor = 0;
		for( var t in pizzaStorage ){
			total += Number( pizzaStorage[t].qnt );
			sabor.push( "<b>"+ConverteFracao( pizzaStorage[t].qnt )+"</b> "+pizzaStorage[t].name );
			valor += Number( pizzaStorage[t].value );
		}

		if( qnt ) total += Number(qnt);

		return { size: total, desc : sabor.join(" / "), value : valor };
	}

	function ShowPizzaDisplay(){
		var ret = PizzaCalculate();
		var perc = (ret.size * 100)+"%";
		var desc = ret.desc
		var valor = ret.value
		$("#displayPizza").load('/includes/displaypizza',function(){

			$('#displayPizza .progress-bar').width( perc ).html( perc );
			$('#displayPizza .description').html( "<kbd>"+ MoneyFormat( valor ) +"</kbd> <b>Sabores</b> : "+desc );
			$('.ok-pizza').unbind('click').click(function(){
				AddPizza()
				return false;
			})
			$('.cancel-pizza').unbind('click').click(function(){
				CancelPizza();
				return false;
			})
		})
	}

	function CancelPizza(){
		if( !confirm('Tem certeza ?') ) return false;
		localStorage.removeItem('pizza');
		$("#displayPizza").html('')
	}

	function AddPizza( confirmed ){

		var pizzaStorage = JSON.parse(localStorage.getItem('pizza'));
		if( !pizzaStorage ) {
			AlertMessage( $('#displayPizza'), "warning", "Oow!", "Não existe nenhuma pizza", 3000 );
			return false;
		}

		var pz = PizzaCalculate();
		if( pz.size < 1 ){
			if( !confirmed ){
					
				ModalConfirm( "Atenção", "Pizza incompleta, deseja continuar ?", function(){
					AddPizza( true );
				})

				return false;
			} 
		}		

		var newline = {	name: "Pizza Mista ("+ pz.desc +")",
						item_value : pz.value,					
						amount : pz.size,
						value : CalculateAmount( pz.size , pz.value ),
						mode : 4,
						id: 1,
						status : "",
						item_id : '',
						descricao : pz.desc };

		// Adiciona nova linha
		ItensVenda.push( newline );	
		localStorage.setItem( 'ItensVenda', JSON.stringify(ItensVenda) );
		localStorage.removeItem('pizza');
		$("#displayPizza").html('');
		LoadItensVenda();
	}

	var mode = 'forma1';

	function CalculteRest( vlr_total, vlr_pago ){
		var troco = '';
		troco = Number(vlr_pago) - Number(vlr_total)
		//console.log( vlr_pago + " - " + vlr_total + " = "+ troco)
		return troco;
	}

	function CalculoDesconto( vlr, desconto ){
		return ( ( desconto * vlr ) / 100 );
	}

	function EfetuarPagamento(){

		if( ItensVenda.length ){

			$('#modal').data('keyboard',false);
			//Modal( "Efetuar Pagamento", 'internals/form.php', function(){ CreateFormPgto() } , 'lg')
			Modal( "Efetuar Pagamento", 'internals/form_pagamento.php', function(){ 
				Keyboard_step = 'payment';
				Payment_step = 'pay_discount';
				CreateFormPgto() 
			} , 'lg', null, null);

		} else {

			AlertMessage( $('#datagrid').parent(), 'warning', "Atenção", "Nenhum item na venda!", 3000 );

		}

	}

	function EfetuarPagamentoConta(){

		//$('#modal').data('keyboard',false);
		Modal( "Pagar Conta Cliente", 'internals/pagar_conta.php', function(){ 
			var formElement = $('#modal .modal-body form');
			formElement.attr('action','');
			CallForm('forms/pagar_conta.json', formElement, function(){

				ComboPessoasFisica( formElement.find('#fisica_id') )
				ComboFormas( formElement.find('#forma_pagto_id'), null, 'c' );
				
				var formas = new $PHP('fpagto_ctl');
				formas.loaded = function(){
					formas.call('selectAll',[0,4,'c'],function( ret ){

						$('.form-group.fracionado').html('')
						var html = '';
						var fracionar = [];
						var len = formas.data.length;
						var pos = '';
						var active = 'active';
						var ind = "first";

						for( var i in formas.data ){
							pos = '';	
							if( i == (formas.data.length - 1) ) ind = 'last';
							html_ = "<div class='col-sm-12 parent'>";
								html_ += "<label class='col-sm-6 control-label'>"+formas.data[i].nome+"</label>";
								html_ += "<div class='col-sm-6'><input class='form-control input-sm focus-select-range "+active+" "+ind+" ' type='text' placeholder='' data-type='money' data-forma='"+formas.data[i].id+"' ></div>";
							html_ += "<div class='clearfix'>&nbsp;</div></div>";
							fracionar.push( html_ )	;	
							active = '';
							ind = '';

						}
						$('.form-group.fracionado').html( "<div class='row fracionar-list form-horizontal'>" + fracionar.join('') +"</div>" )
						
						$('.fracionar-list input').unbind('keydown').keydown(function( e ){

							if( e.which == 13 ){

								if( $(this).hasClass('last') ){

									LancaCredito()

								} else {

									var next = $(this).parents('.parent:eq(0)').next().find('input')

									if( PegaValorFracionado() && !next.val() ){
										next.val( DiferencaValorFrancioado_() )	
									}
									
									next.focus();		

								}
								

								return false;
							}

							if( e.which == 27 ){

								if( $(this).hasClass('first') ){
									$('#forma_pagto_id').focus()
								} else {
									$(this).val('0.00');
									$(this).parents('.parent:eq(0)').prev().find('input').focus();	
								}								

								return false;
							}

						}).unbind('keyup').keyup(function(){
							formElement.find('#valor').val( MoneyFormat( PegaValorFracionado() , '', ".") );
							MostraDisplayPC(formElement)
						})

						InitInputs()

					})
				}

				initJs();

				InitFormPagamentoConta(formElement)

			}, function( ret ){

					

			})
		}, 'lg', null, null);

	}

	function FechamentoCaixa(){

		if( !ItensVenda.length ){

			Modal( "Fechamento de Caixa", 'internals/fechar_caixa.php', function(){
				
				setTimeout(function(){$('#valor_fechamento').focus()},500);
				
			} , 'md');

		} else {

			AlertMessage( $('#datagrid').parent(), 'warning', "Atenção", "Existe uma venda aberta. Feche ou conclua!", 3000 );

		}

	}



	function LimparTelaVenda(){

		ItensVenda.length = 0;
		localStorage.setItem('ItensVenda','');
		LoadItensVenda();

	}

	function ConfereValorVenda(){

		var vlr_total = ConvertMoneytoFloat( $('#total').text() );
		var vlr_pago = dataSell.vlr_pago;

		if( !vlr_pago ){  
			return 2;
		}

		if( vlr_pago < vlr_total ){
			return 3;
		}

		return 1;

	}

	function DiferencaValor(){
		var vlr_total =  ConvertMoneytoFloat( $('#total').text() );
		var vlr_pago = PegaValorPago();
		
		return Number( (vlr_total - vlr_pago) );	
	}


	function CreateFormPgto(){

		

	}

	var dataPC = 	{	
						saldo : 0,
						desconto : 0,
						vlr_pago : 0
					}
	function InitFormPagamentoConta( formElement ){

		Keyboard_step = 'pagar_conta';
		formElement.find('#desconto,#forma_pagto_id,#valor').attr('disabled','disabled');
		$('.form-group.fracionado').hide();

		/*
		formElement.find('#desconto').unbind('keyup').keyup(function(){
			MostraDisplayPC(formElement);
		})
		*/

		formElement.find('#desconto').twovalues({
		loaded: function(){
			$('.twov input').attr('disabled','disabled').css('width','80%');
			$('.twov:eq(0) input').decimal(2);

		},
		input_1 : { symbol: '%', 
					label: 'Porcentagem', 
					class : 'focus-select-range',  
					keydown: function( e ){
						if( e.which == 32 ){													

							$(this).parents('.twov:eq(0)')
							.hide()
							.removeClass('active')
							.next()
							.addClass('active')
							.show()
							.find('input')
							.focus()

							return false;
						}

						if( e.which == 13 ){

							$(this).parents('.form-group:eq(0)').next().find('input,select').focus();	

							return false;
						}
					},
					keyup: function( e ){

						formElement.find('#desconto').val( $(this).val() )
						//var res = AplicaDesconto();
						MostraDisplayPC(formElement);

						/*
						$(this).parents('.twov:eq(0)')
						.next()
						.find('input')
						.val( MoneyFormat( res.vlr_desconto , '', ".") )
						*/

						/*
						$(this).parents('.twov:eq(0)')
						.parent()
						.find('.help-block')
						.html( "Desconto de "+MoneyFormat( vlr_desconto ) )
						*/
						

					}, 
					active : 'active',
					type : "" },
		input_2 : { symbol: '$', 
					label: 'Monetário', 
					class : 'focus-select-range', 
					keydown: function( e ){
						if( e.which == 32 ){														
								
							$(this).parents('.twov:eq(0)')
							.hide()
							.removeClass('active')
							.prev()
							.addClass('active')
							.show()
							.find('input')
							.focus()

							return false;
						}

						if( e.which == 13 ){

							$(this).parents('.form-group:eq(0)').next().find('input,select').focus();	

							return false;
						}
					},
					keyup: function( e ){

						var perc = ConvertValorEmPerc( Number($(this).val()), dataPC.saldo);
						formElement.find('#desconto').val( perc )
						//var res = AplicaDesconto();
						MostraDisplayPC(formElement);

						/*$(this).parents('.twov:eq(0)')
						.prev()
						.find('input')
						.val( perc )

						$(this).parents('.twov:eq(0)')
						.parent()
						.find('.help-block')
						.html( "Desconto de "+Number(perc)+" %" )*/

					},
					type : "money" }
		})


		formElement.find('#valor').unbind('keyup').keyup(function(){
			MostraDisplayPC(formElement);			
		})

		formElement.find('#valor,#forma_pagto_id').unbind('keydown').keydown(function( e ){

			if( e.which == 13 ){

				if( $(this).hasClass('last') ){
					LancaCredito()
				} else {
					$(this).parents('.form-group:eq(0)').next().find('input,select').focus();	
				}
				

				return false;
			}

			if( e.which == 27 ){

				$(this).parents('.form-group:eq(0)').prev().find('input,select').focus();

				return false;
			}

		})

		$('#forma_pagto_id').unbind('keydown').keydown(function( e ){
			switch( e.which ){
				case 13:
					$(this).parents('.form-group:eq(0)').next().find('input,select').focus();
					break;
				case 27: $(this).parents('.form-group:eq(0)').prev().find('input,select').focus(); return false; break;
				case 49: case 97: $(this).val(1); break;
				case 50: case 98: $(this).val(2); break;
				case 51: case 99: $(this).val(3); break;				
				case 52: case 100: $(this).val(5); break;
			}

			$(this).change()

			return false;
		}).unbind('change').change(function(){
			if( $(this).val() == 5 ){
				$('.form-group.valor').hide();
				$('.form-group.fracionado').show();
				$('.fracionar-list input:eq(0)').focus();
			} else {
				$('.form-group.fracionado').hide();
				$('.form-group.valor').show();
			}
		})


		setTimeout(function(){ formElement.find('.form-group.fisica_id button:eq(0)').focus() }, 500 );
		$('#fisica_id').on('change', function(){
		   	formElement.find('.alert').remove();
		   	formElement.find('#desconto,#forma_pagto_id,#valor').attr('disabled','disabled');
		   	$('.twov input').attr('disabled','disabled');
			$('.form-group.fracionado').hide();

		   	var id = $('.selectpicker option:selected').val();

			if( id ){
				var pessoas = new $PHP('buyer_ctl');
			   	pessoas.loaded = function(){
					pessoas.call('selectById',[id],function( ret ){

						console.log( pessoas.data )

						if(ret.success){
							dataPC.saldo = Math.abs(pessoas.data.saldo);

							if( pessoas.data.saldo != '0'){
								formElement.find('#desconto,#forma_pagto_id,#valor').removeAttr('disabled');	
								$('.twov input').removeAttr('disabled')							
								MostraDisplayPC( formElement )
								//$('#desconto').focus();								
								$('.twov:eq(0) input').focus();

							} else {

								AlertMessage( formElement, 'warning', "Atenção!", "Cliente sem débitos!" );

							}

							
						}
					})
				};
			}		   	

		});
	}

	function MostraDisplayPC( formElement ){
		$('.resumo-conta-cliente').show();
		var vlr_total = dataPC.saldo;
		var desconto = Number( formElement.find('#desconto').val() );

		var vlr_desconto = CalculoDesconto( vlr_total, desconto );
		vlr_total -= vlr_desconto;

		var valor = Number( formElement.find('#valor').val() );
		var rest = CalculteRest( vlr_total, valor );
		if( rest < 0 ) rest = 0;

		$('.resumo-conta-cliente .total').html( "<kbd>Débito</kbd> "+MoneyFormat( vlr_total ) );
		$('.resumo-conta-cliente .pago').html( "<kbd>Pago</kbd> "+MoneyFormat( valor ) );
		$('.resumo-conta-cliente .troco').html( "<kbd>Troco</kbd> "+MoneyFormat( rest ) );
		$('.resumo-conta-cliente .off').html( "<kbd>Econ.</kbd> "+MoneyFormat( vlr_desconto ) );
	}

	function PegaValorFracionado(){

		var vlr_pago = 0;
		$('.fracionar-list input').each(function(){
			vlr_pago += Number($(this).val())
		})
		
		return vlr_pago;
	}

	function DiferencaValorFrancioado_(){
		var vlr_total =  dataPC.saldo;
		var vlr_pago = PegaValorFracionado();
		var calc = Number( vlr_total - vlr_pago );

		return calc.toFixed(2);	
	}

	function LancaCredito( confirm ){
		var formElement = $('#modal .modal-body form');
		formElement.find('.alert').remove()

		if( confirm ){

			var dataSend = SerializeObject(formElement.serializeArray());
			var fracionado = new Object();
			if( $('#forma_pagto_id').val() == 5 ){
				$('.fracionar-list input').each(function(){
					fracionado[ $(this).data('forma') ] = Number($(this).val())
				})

				dataSend.fracionado = fracionado;			
			}

			// Envia as informações ...
			fisicaConta.call('save',[JSON.stringify( dataSend )],function( ret ){
				if(ret.success){

					$('.modal-close').click();
					AlertMessage( $('#datagrid').parent(), 'success', "Sucesso!", "Pagamento efetuado com sucesso!", 3000 );

				} else {

					var msg = ret.message;

					if( typeof ret.message === 'object' ){
						var msg_ar = [];
						for( var i in ret.message ){
							msg_ar.push( ret.message[i] );
						}
						msg = msg_ar.join('<BR>');
					} 
					
					AlertMessage( formElement, 'warning', "Erro!", msg );
					

				}
			})	
		} else {

			ModalConfirm( 	'Confirmar Pagamento', 
							'Pressione ENTER para Confirmar e ESC para Cancelar', 
							function(){
								LancaCredito( true )
							},
							function(){

								formElement.find('#valor').focus()

							} )

		}		

	}

	function ConvertValorParaPeso( vlr ){
		var formElement = $('#modal .modal-body form');
		var vlr_produto = formElement.find('#valor').val();
		var calc = Number(vlr / vlr_produto);
		var rd = Math.ceil(calc)

		return  calc;	
	}

	function ConvertValorEmPerc( vlr, total ){
		var total_venda = Number(total) ;
		var calc = Number((vlr / total_venda)*100);
		//var rd = Math.ceil(calc)

		return  calc.toFixed(2);	
	}

	function PesquisaProduto(){
		Keyboard_step = 'pesquisa';
		Modal( 'Pesquisar Produtos', 'internals/pesquisa.php', function(){					

		}, 'lg')
	}

	function PesquisaVenda(){
		Modal( 'Pesquisar Venda', 'internals/pesquisa_vendas.php', function(){					

			
		}, 'lg')
	}

</script>
