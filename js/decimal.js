// JavaScript Document
(function($){
	
	$.fn.decimal = function(settings){

		var Element = $(this);
		var me = this;
		var config = {
		};		
		var last_keypress = '';

		var formatDecimal = function( vlr ){
			vlr = vlr.replace(/[^0-9]/g,'');
			vlr = strpad( vlr, settings + 1 , '0', 'L' );
			var ex = "(.*)([0-9]{"+settings+"}$)";
			var regex = new RegExp(ex);
			vlr = vlr.replace( regex ,'$1.$2');
			return vlr;

		}

		this.apply = function( dec ){
			
			if( !Element.attr('done') ){

				Element.val(formatDecimal( Element.val() ));

				var parent = Element.parent();	
				Element.attr('done',true);
				Element.keypress(function( e ){
					
					//alert( this.last_keypress )
 					
 					var data = String.fromCharCode(e.which);
 					var vlr = $(this).val();

					if( $.isNumeric( data ) === true ){
						//this.last_keypress = data;
						vlr = String($(this).val()) + String(data);
						vlr = formatDecimal(vlr);

						$(this).val(vlr);						
					} 

					this.last_keypress = '';
					return false;

				}).keyup(function(){
					var vlr = $(this).val();
					vlr = formatDecimal(vlr);

					$(this).val(vlr);	
				})
			}
			
		}


		// pegas as propriedades da função e transfere para o objeto
		if (typeof settings === 'object' || !settings ){

			this.filter('input').each(function(){
				$.extend(config, settings);
				Element = $( this );		

				me.apply();	 	

			})			
			
	        return this;
		}


		if (typeof settings === 'string') {
			var fun = eval(settings);
			fun.apply()
		}

		if (typeof settings === 'number') {
			this.filter('input').each(function(){
				Element = $( this );		
				me.apply( settings );	 	

			})
			return this;
		}
		
		
		
	}


})(jQuery);