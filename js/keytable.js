// JavaScript Document

var KeyTableInstance = [];

(function($){
	$.fn.keytable = function(settings, param){

		this.Element = $(this);
		var me = this;
		var config = {			
			limit : 7
		};	


		this.config = config;
		this.lastIndex = null;

		this.apply = function(){
			
			Element.attr('data-config', JSON.stringify( config ) )

			me.TopDown()

			Element.unbind('click').click(function(){				
				//me.selectTr( Element.find('tbody tr:not(:hidden):eq(0)') )
				Element.trigger('focus')
			})


			//addArrows()

		}	

		this.getConfig = function(){
			return JSON.parse( Element.attr('data-config') )
		} 

		var addArrows = function(){

			Element.css( "position", "relative" )

			$(".kt-arrow").remove()
			var divImage = $('<div>');
				divImage.addClass("kt-arrow");	
				divImage.addClass("down");	
				divImage.addClass("inative");	
				Element.after( divImage )

			var divImage = $('<div>');
				divImage.addClass("kt-arrow");	
				divImage.addClass("up");	
				divImage.addClass("inative");	
				Element.after( divImage )


			RefreshArrows();
		}

		var RefreshArrows = function(){
			/*
			var qnt_hid = Element.find('tbody tr:hidden').length

			if( qnt_hid ){

				if( Element.find("tbody tr:last-child").is(":hidden") ){
					$('.kt-arrow.down').removeClass('inative')
				} else {
					$('.kt-arrow.down').addClass('inative')
				}
				
				if( Element.find("tbody tr:first-child").is(":hidden") ){
					$('.kt-arrow.up').removeClass('inative')
				} else {
					$('.kt-arrow.up').addClass('inative')
				}
			}
			*/
		}


		var trSelected = null;

		this.Key = function( keycode ){

			var cfg = me.getConfig();
			var table = Element;

			var trAtual = table.find('tbody tr.selected');
			var index = trAtual.index() ;

			//if( !trAtual.length ) me.selectTr( table.find('tbody tr:eq(0)') )

			switch( keycode ){
				// Para baixo
				case 40:
						if( trAtual.is(":last-child") ){
							Element.trigger('escapeDown')
						} else {

							me.selectTr( trAtual.next() )

							if( trAtual.next().is(":hidden") ) {
								me.MoveDown()
							}
						}						
						
						return false;

					break;

				// Para cima
				case 38:

						if( trAtual.is(":first-child") ){
							Element.trigger('escapeUp')
						} else {

							//trAtual.prev().css('background','red')
							
							me.selectTr( trAtual.prev() )
							
							if( trAtual.prev().is(":hidden") ) {
								me.MoveUp()
							}
							
						}						

						return false;

					break;

				// MAIS
				case 107:

						/*
						AdicionaRemoveItem( id, 1 );
		    			LoadItensVenda();
		    			table.find('tbody tr:eq('+index+')').addClass('selected');
						return false;
						*/
						
						return false;

					break;

				// DELETE
				case 46:
				case 109:

						var prev = me.trSelected.prev();
						if( Element.trigger('delete', [me.trSelected] ) ){
								
							var tr = Element.find('tbody tr:eq('+me.lastIndex+')')
							if( tr.length ){
								me.selectTr( tr )	
							} else {
								me.selectTr( Element.find('tbody tr:eq('+ (me.lastIndex-1) +')') )	
							}								

						}  
													
						if( !Element.find('tbody tr.selected').length ){							
							Element.trigger('blur')				
						}

						return false;
						
					break;

			}
		}	

		this.TopDown = function(){
			var cfg = me.getConfig();
			if( Element.find( "tbody tr").length - 1 > Number(cfg.limit) ){
				Element.find('tr').hide()
				Element.find( "tbody tr:lt("+Number(cfg.limit) +")" ).show()
			}
			Element.find( "thead tr:eq(0)" ).show()
		}

		this.MoveDown = function(){
			var cfg = me.getConfig();
			var tr = me.trSelected;
			var index = tr.index() ;
			Element.find("tbody").find("tr").show();
			var hideIndex = ( (index) - Number(cfg.limit) ) 

			Element.find("tbody").find("tr:lt("+ (hideIndex+1) +" )").hide()
			Element.find("tbody").find("tr:gt("+ (index) +" )").hide()
			//RefreshArrows()
		}

		this.MoveUp = function(){
			
			var cfg = me.getConfig();
			var tr = me.trSelected;
			var index = tr.index() ;
			Element.find("tbody").find("tr").show();

			Element.find("tbody").find("tr:lt("+ (index) +" )").hide()
			Element.find("tbody").find("tr:gt("+ (index + (cfg.limit-1) ) +" )").hide()

			
		}

		this.selectTr = function( tr ){
			
			me.lastIndex = tr.index();
			var table = Element;
			table.find('tr').removeClass('selected')
			tr.addClass('selected')//.show();
			me.trSelected = tr;
			
		}

		this.deSelectAll = function(){
			Element.find('tr').removeClass('selected')
		}


		this.focus = function(){
			Element.addClass('focused');
			me.selectTr( Element.find('tr:eq(1)') )
		}

		var Key = function( k ){
			me.Key( k )
		}

		// pegas as propriedades da função e transfere para o objeto
		if (typeof settings === 'object' || !settings){

			if( settings ){
				me.filter('table').each(function(){
					$.extend(me.config, settings);
				})	

				Element = $( this );
				me.apply()

			} else {

				$.extend(me.config,  JSON.parse( Element.attr('data-config') ) );

			}

			
			
			if( KeyTableInstance[ Element.attr('id') ] )  return KeyTableInstance[Element.attr('id') ];
			KeyTableInstance[ Element.attr('id') ] = this;
	        return this;
		}
		


		if (typeof settings === 'string') {
			return this;
		}
		
	}


})(jQuery);