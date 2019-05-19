var pageActived = [];
var Keyboard_step = 'sell';
var Payment_step = 'pay_discount';
var uri = '';
var confirming = false;
var phpHelp = new $PHP('helpController');

$(function(){

	//if( localStorage.getItem('pageActived') ) pageActived = JSON.parse( localStorage.getItem('pageActived') );

	// Verifica Login
	//VerifyAutentication();
	MenuSystem()
	
	/*$.ajaxSetup({
	  beforeSend : function(){
	  	 $('body').block ({ 	message: 'Carregando...',
								css: { 
						            border: 'none', 
						            padding: '15px', 
						            backgroundColor: '#fff', 
						            '-webkit-border-radius': '10px', 
						            '-moz-border-radius': '10px', 
						            opacity: .5, 
						            color: '#000'
						        }
					    });
	  }
	});
	$(document).ajaxSuccess(function() {
	 	$('body').unblock(); 
	});*/

	// Ao ocultar o modal...
	$('#modal').on('hidden.bs.modal', function (e) {

		Keyboard_step = 'sell';
		Payment_step = 'pay_discount';
		// limpa o conteudo
	  	$('#modal').find('.modal-body').html('');
	  	$('#produto').focus();
	  	$('#modal').data('keyboard',true);
	  	$(this).removeData();

	})

	if( uri && uri.indexOf('sell.php') != -1 ){
		if( $('#datagrid').length ){
			initKeyTable();
		} 
	}

	initJs();


})

var called = false;
var DataTable = null;

var interval = null;
var ItensVenda = [];

if( localStorage.getItem( 'ItensVenda' ) ) ItensVenda = JSON.parse( localStorage.getItem( 'ItensVenda' ) );

// Func? que inicia o Js das telas
function initJs(){

	//$('#content').css('background','#CCC');
	$('#content').responsive({direction:'vertical',
							  padding:[0,0, ( $('.navbar').height() + $('.footer').height() + 50) ,0]});

	// Auto loads de Divs com href
	$('div[href]').not('.done').each( function(){
		salling = false;
		// Element
		var me = $(this);
		// Garante n? carregar 2 vezes
		me.addClass('done');
		// Carrega o ajax pelo HREF

		var callback = me.attr('callback');
		//pageActived = [me.attr('href'),callback,me.attr('id')];
		//localStorage.setItem('pageActived',JSON.stringify(pageActived))

		var href = me.attr('href');
		uri = href

		me.load( href, function(){
			// callback padr?
			initJs()
			if( callback ) {
				var func = eval( callback );
				func.apply()
			}
		})
	})

	// Link da tag A em ajax
	//$("a[href!='#']:not(.ahref,.paginate_button,.collapse)").css('color',"#889966")
	$("a[href!='#']:not(.ahref,.paginate_button)").unbind('click').click( function(){

		if( $(this).hasClass('unlink') ) return false;

		salling = false;
		// Element
		var me = $(this);
		// Href do link
		var href = me.attr('href');
		var callback = me.attr('callback');
		// Onde vai carregar ?
		var local = $(me.attr('target'));

		//pageActived = [me.attr('href'),callback,local.attr('id')];
		//localStorage.setItem('pageActived',JSON.stringify(pageActived))

		uri = href

		// Se for de um li
		if( me.parent().is('li') ){
			// Define todos os outros li como n? ativos
			me.parents('ul:eq(0)').find('li').removeClass('active');
			// Ativa o li atual
			me.parent().addClass('active')
		}
		
		// Ajax para carregar o href
		local.load( href, function(){
			// callback padr?
			initJs()
			if( callback ) {
				var func = eval( callback );
				func.apply()
			}
		})

		var dropdown = $(this).parents('.dropdown-menu:eq(0)')

		if( dropdown ){				
			dropdown.dropdown('toggle')
			// Se for de um li
			if( dropdown.parent().is('li') ){
				// Define todos os outros li como n? ativos
				dropdown.parents('ul:eq(0)').find('li').removeClass('active');
				// Ativa o li atual
				dropdown.parent().addClass('active')
			}	
		}

		return false;
	})

	$("a.unlink").unbind('click').click( function(){ 
		return false;
	})

	// Links de Modal
	$('[modal]').unbind('click').click( function(){
		// Element
		var me = $(this);
		// O href pelo atributo Modal
		var url = me.attr('modal');
		// Titulo do modal
		var title = me.data('modaltitle');
		// Callback do modal
		var callback = me.attr('callback');

		var modalsize = me.attr('modalsize');

		Modal( title, url, callback, modalsize, $(this).attr('id') )

		return false;
	})

	$('.btn.help').each(function(){
		var placement = $(this).attr('placement');
		$(this).popover({
			html : true,
			placement: placement,
			content: "",
			title:"Ajuda"
		}).on('hidden.bs.popover', function () {
  			//$(this).popover('destroy')
		})
	})

	$('.btn.help').unbind('click').click(function(){

		$('#modal-help').modal({keyboard: true, 
								backdrop: 'static'});
		var contentElement = $('#modal-help .modal-body .well');
		var titleElement = $('#modal-help .modal-title');

		var help_item_id = $(this).data('help');

		contentElement.html("<div class='loading'></div>");
		phpHelp.call('getItem',[help_item_id],function(){

			var title = "<b>"+phpHelp.data.parent+" / "+phpHelp.data.title_item+"</b>";
			var content = "<br>"+phpHelp.data.resume+"<br><br><a href='/internals/ajuda.php' target='#page-content'>Leia mais no Manual do Sistema</a>";
			contentElement.html(title+content);
			initJs();
			contentElement.find('a').click(function(){
				$('#modal-help').modal('hide')
			})

		})

		return false;
	})
	

	$('[data-toggle="tooltip"]').tooltip()

	$('#logoff').unbind('click').click(function(){
		logoff()
		return false;
	})

	InitInputs()

}

function initKeyTable(){
	$('#datagrid').keytable({
		limit : 10
	})
	.off('escapeUp').on( 'escapeUp',{}, function(){
		$('#datagrid').keytable().deSelectAll();
		$("#produto").focus()
	})
	.off('delete').on('delete',function( event, trAtual ){
		var id = trAtual.attr('id');
		AdicionaRemoveItem( id, -1 );
		LoadItensVenda();		
		return true;
	})
	.off('blur').on('blur',{},function(){
		if( !ItensVenda.length ){
			$("#produto").focus()
		} 
	})
	.off('focus').on('focus',{},function( table ){
		table.addClass('focused');
		$("#produto").blur();
		Keyboard_step = 'itens';
	})

}

function InitInputs(){
	// Campos somente númericos
	$("[data-type=number]").unbind('keypress').keypress(function( e ){
		// pego o dado digitado
		var data = String.fromCharCode(e.which);
		// se for numero returna true
		return $.isNumeric( data );
	})
	$('[data-type=money]').maskMoney({allowNegative: false, thousands:'', decimal:'.', affixesStay: false});
	$('[data-type=decimal]').decimal(2);

	$('.datepicker').datetimepicker({
		format: 'DD/MM/YYYY',
		locale:'pt-br'
	})
	$('.focus-select-range').focus(function(){
		/*if( !Number($(this).val()) )*/ $(this).selectRange(0,100);
	})
	$("[data-type=telefone]").mask(SPMaskBehavior, spOptions);
	$("[data-type=date]").mask('99/99/9999');
}

var combo_bkp = [];

function ComboCategorias( where, callback ){

	/*if( where.attr('backup') ){
		if( combo_bkp[where.attr('backup')] ){
			setOptionData( where, combo_bkp[where.attr('backup')], ['id','nome'], ['',''] );
			if( callback ) callback()
			return true;
		}
	}*/

	var categorias = new $PHP('categoriaController');
	categorias.loaded = function(){
		categorias.call('selectAll',[0,100],function( ret ){
			combo_bkp['ComboCategorias'] = categorias.data;
			setOptionData( where, categorias.data, ['id','nome'], ['',''] );
			if( callback ) callback()
		})
	};
}

function ComboUnidade( where, callback ){

	if( where.attr('backup') ){
		if( combo_bkp[where.attr('backup')] ){
			setOptionData( where, combo_bkp[where.attr('backup')], ['id','nome'], ['',''] );
			if( callback ) callback()
			return true;
		}
	}

	var unidade = new $PHP('unidadeController');
	unidade.loaded = function(){
		unidade.call('selectAll',[0,100,'y'],function( ret ){
			combo_bkp['ComboUnidade'] = unidade.data;
			setOptionData( where, unidade.data, ['id','descricao'], ['',''] );
			if( callback ) callback()
		})
	};
}

function ComboProdutos( where, callback ){

	var produtos = new $PHP('produto_ctl');
	produtos.loaded = function(){
		produtos.call('selectAll',[0,100,'y'],function( ret ){
			setOptionData( where, produtos.data, ['id','nome'], ['',''] ).selectpicker({
				liveSearch:true
			});
			if( callback ) callback()
		})
	};
}

function ComboPessoasJuridica( where, callback ){

	var pessoasPJ = new $PHP('juridicaController');
	pessoasPJ.loaded = function(){
		pessoasPJ.call('selectAll',[0,100],function( ret ){
			setOptionData( where, pessoasPJ.data, ['id','razao_social'], ['',''] ).selectpicker({
				liveSearch:true
			});
			if( callback ) callback()
		})
	};
}

function ComboPessoasFisica( where, callback ){

	var pessoasPF = new $PHP('buyer_ctl');
	pessoasPF.loaded = function(){
		pessoasPF.call('selectAll',[0,100,'y'],function( ret ){
			setOptionData( where, pessoasPF.data, ['id','nome'], ['',''] ).selectpicker({
				liveSearch:true,
				size: false
			});
			if( callback ) callback()
		})
	};
}

function ComboFormas( where, callback, active ){

	if( !active ) active = '';

	var formas = new $PHP('fpagto_ctl');
	formas.loaded = function(){
		formas.call('selectAll',[0,100, active],function( ret ){
			formas.data.push({id:5,nome:"Fracionado"})
			setOptionData( where, formas.data, ['id','nome'], null )
		})
	};
}


function MenuSystem(){
	var modulo = new $PHP('module');
	modulo.loaded = function(){
		modulo.call('selectAll',[0,100],function( ret ){
			
			var menuElement = $('#menu-system')
			var active = 'active';

			var li = "";
			var last_pai = "";
			var pai,link,text,id;
			var sub = [];

			for( var i in modulo.data ){
										
				li = "";

				pai = modulo.data[i].pai;
				link = modulo.data[i].link;
				text = modulo.data[i].text;
				id = modulo.data[i].id;

				if( !pai ){	
					if( link ){
						li = "<li class='"+active+"'>";
							li += "<a href='"+link+"' class='link_menu_"+id+"' target='#page-content' >";
								li += text;
							li += "</a>";
						li += "</li>";
					} else {
						li = "<li class='dropdown'>";
							li += "<a href='#' class='dropdown-toggle link_menu_"+id+"' data-toggle='dropdown' role='button' aria-haspopup='true' aria-expanded='false' >";
								li += text;
								li += "<span class='caret'></span> ";
							li += "</a>";
							li += "<ul class='dropdown-menu parent_"+id+"'></ul>";
						li += "</li>";
					}
					
					menuElement.append( li );

				} else {
					if( !sub[pai] ) sub[pai] = [];
					sub[pai].push( "<li><a href='"+link+"' target='#page-content'>"+text+"</a></li>" )
				}

				active = '';
			}

			for( var s in sub ){
				$("ul.dropdown-menu.parent_"+s).append( sub[s].join('') );
			}

			delete(sub)
			console.log( sub )
			initJs()

		})
	};
}

/*
var notification = new $PHP('notificationController');
	notification.preload = "";
	notification.loaded = VerifyNotification;
function VerifyNotification( ){
	notification.call('Notifications',[0,100],function( ret ){



		setTimeout( function(){
			VerifyNotification( )
		}, 1000)
	})
}
*/



