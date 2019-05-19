var $PHP = function( phpClass ) { 

	this.server = ( server ? server : '' );
	this.class = phpClass;
	this.params = "";
	this.loaded = '';
	this.url = '';
	this.sendException = ( sendException ? sendException : '' );
	this.preload = ( phpjs_preload ? phpjs_preload : null );
	this.complete = ( phpjs_complete ? phpjs_complete : null );
	this.new = function( cls, callback ){

						var me = this;
						me.class = cls;

						$.ajax({
							url: this.server+"/"+cls,
							dataType : "json",
							success : function( ret ){
								if( ret.success ){		

									me.fillproperty( ret.data.attributes );
									if( me.loaded ) me.loaded();
									if(callback) callback();
								}
							}
						})

				};


	if( phpClass ){
		this.new( phpClass );
	}

	this.call = function( method, params, callback ){

		if( this.preload ){
			this.preload();
		}

		//var method = this.getMethod( arguments.callee.caller );
		var me = this;
		me.params = params;
		this.url = this.server+"/"+this.class+'/'+method;
		//console.log( this.sendException )
		if( this.sendException ){
			for( var e in this.sendException ){
				delete me[this.sendException[e]];
			}
		}

		var complete = this.complete;

		$.ajax({
			url: this.url,
			dataType : "json",
			data: JSON.stringify(me),
			type: 'POST',
			success : function( ret ){
				me.fillproperty( ret.data.attributes );
				//if( ret.success ){
					if(callback) callback( ret );	
				//}
				
			},
			complete : function(){
				if( complete ){
					complete();
				}
			}
		})
	}

	this.fillproperty = function( attributes ){
		for( var a in attributes ){
			this[a] = attributes[a]
		}
	}
}