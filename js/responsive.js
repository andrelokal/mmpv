// JavaScript Document
(function($){
	// Cria um form dinamicamete
	$.fn.responsive = function(settings){

		var Element = $(this);
		var me = this;
		var config = {
			padding : [0,0,0,0], // top, right, bottom, left,
			direction : "all",
			size : [100,100]
		};		

		this.expands = function(){
			var parent = Element.parent();

			//parent.css('position','relative');

			var T = config.padding[0];
			var R = config.padding[1];
			var B = config.padding[2];
			var L = config.padding[3];

			Element.css({
				position 		: 'relative',
				top				: T,
				left			: L,
				'box-sizing' 	: 'border-box'
 			})

			var sizeW = config.size[0]; 
			var sizeH = config.size[1]; 

			sizeH = sizeH * parent.innerHeight() / 100;
			/*if( typeof sizeW === 'string' ){
				sizeH = this.extract_perc( sizeH ) * parent.innerHeight() / 100;
			}*/

			sizeW = sizeW * parent.innerWidth() / 100;
			/*if( typeof sizeW === 'string' ){
				sizeW = this.extract_perc( sizeW ) * parent.innerWidth() / 100;
			}*/

 			var w = sizeW - (R + L );
 			var h = sizeH - (B + T );

			if( config.direction == 'all' || config.direction == 'horizontal' ) Element.width( w );			
			if( config.direction == 'all' || config.direction == 'vertical' ) Element.height( h );
		}

		this.extract_perc = function( str ){
			var regex = /([0-9]+)\%/;
			var m;
			while ((m = regex.exec(str)) !== null) {
			    return Number(m[1]);
			}
		}

		// pegas as propriedades da função e transfere para o objeto
		if (typeof settings === 'object' || !settings){

			this.filter('*').each(function(){
				$.extend(config, settings);
				Element = $( this );		

				$( window ).unbind('resize').resize(function() {
					me.expands();
				});
				$( window ).resize();		 	
			})			
			
	        return this;
		}


		if (typeof settings === 'string') {
			var fun = eval(settings);
			fun.apply()
		}
		
		
		
	}


})(jQuery);