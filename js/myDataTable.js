// JavaScript Document
(function($){
	// Cria um form dinamicamete
	$.fn.datatable = function(settings){

		var Element = $(this);
		var me = this;
		var config = {
			columns : [],
			data : [],
			ajax : "",
			rowId : ''
		};		

		this.draw = function(){
			alert('oi')
			Element.html('');
			this.addColumns();

		}

		this.addColumns = function(){

			if( config.columns ){

				var thead = $('thead');

				for( var c in config.columns ){
					var th = $('th')
					th.html( config.columns[c].title );
					thead.append( th )
				}
			}

		}

		// pegas as propriedades da função e transfere para o objeto
		if (typeof settings === 'object' || !settings){

			this.filter('table').each(function(){
				$.extend(config, settings);
				Element = $( this );		

				this.draw()
			})			
			
	        return this;
		}


		if (typeof settings === 'string') {
			var fun = eval(settings);
			fun.apply()
		}
		
		
		
	}


})(jQuery);