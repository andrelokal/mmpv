// JavaScript Document
(function($){
	
	$.fn.twovalues = function(settings){

		var Element = $(this);
		var me = this;
		var config = {
			input_1 : { symbol: '%', label: 'Porcentagem', class : '',  keydown: null, keyup: null, active : 'active', type:'' },
			input_2 : { symbol: '$', label: 'Monetário', class : '', keydown: null, keyup: null , active : '', type:''},
			loaded: ''
		};		

		this.apply = function(){
			
			var parent = Element.parent();
			Element.hide();

			parent.find('.twov').remove()

			Element.after("<div class='twov twov_field_1 "+config.input_1.active+"' ></div><div class='twov twov_field_2 "+config.input_2.active+"''></div><span class='twov-help help-block '></span>");
			
			var input_1 = 	' <div class="input-group">';
				input_1 += 	' <span class="input-group-addon" > '+config.input_1.symbol+' </span> ';
				input_1 +=	' <input type="text" class="form-control '+config.input_1.class+'" placeholder="'+config.input_1.label+'" aria-describedby="basic-addon1" data-type="'+config.input_1.type+'">';
				input_1 +=	' </div>';

			parent.find('.twov_field_1').html( input_1 )

			var input_2 = 	' <div class="input-group">';
				input_2 += 	' <span class="input-group-addon" > '+config.input_2.symbol+' </span> ';
				input_2 +=	' <input type="text" class="form-control '+config.input_2.class+'" placeholder="'+config.input_2.label+'" aria-describedby="basic-addon1" data-type="'+config.input_2.type+'">';
				input_2 +=	' </div>';

			parent.find('.twov_field_2').html( input_2 );
			
			parent.find('.twov').hide();
			parent.find('.twov.active').show();

			if( config.input_1.keyup ){
				parent.find('.twov_field_1 input').unbind('keyup').keyup(config.input_1.keyup)
			}
			if( config.input_1.keydown ){
				parent.find('.twov_field_1 input').unbind('keydown').keydown(config.input_1.keydown)
			}

			if( config.input_2.keyup ){
				parent.find('.twov_field_2 input').unbind('keyup').keyup(config.input_2.keyup)
			}
			if( config.input_2.keydown ){
				parent.find('.twov_field_2 input').unbind('keydown').keydown(config.input_2.keydown)
			}

			if( config.loaded ) config.loaded()
		}


		// pegas as propriedades da função e transfere para o objeto
		if (typeof settings === 'object' || !settings){

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
		
		
		
	}


})(jQuery);