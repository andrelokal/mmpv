function VerifyAutentication(){
	if( location.href.indexOf('login') == -1 ){
		var auth = localStorage.getItem('auth');
		if( !auth ){
			location.href = '/login/';
		} else {
			$('html').fadeIn(1000);
		}

	}
}


function logoff(){
	var login = new $PHP('loginController');
        login.sendException = ['obj','data','msg','sendException'];
    login.loaded = function(){
      login.call('logoff',[],function( ret ){
        if(ret.success){
          
          localStorage.setItem('auth',null);
          location.href = '/login/'

        } else {

        }
      })
    };
}

function setOptionData( select, data, ref, first ){
	
	select.html('');
	if(first){
		select.append("<option value='"+first[0]+"'>"+first[1]+"</option>");
	}
	for( var i in data ){
		select.append("<option value='"+data[i][ref[0]]+"'>"+data[i][ref[1]]+"</option>");
	}

	return select;
}

// Preenche 'zeros' string
function strpad( vlr, q, p, d ){

	vlr = vlr.replace(/^[0]+/,'');
	pad = new Array(q+1).join('0');

	//if( vlr == '' ) console.log("strpad :"+pad);

	if( vlr.length < q ){		

		switch( d ){
			case 'L':
				return (pad + vlr).slice(-q);
				break;
			case 'R':
				return (vlr + pad).slice(0,q);
				break;
		}		
	} else {
		return vlr;
	}	

}

function SerializeObject( data ){
	var obj = new Object();
	for( var i in data ){

		
		obj[data[i].name] = data[i].value

		//ret.push(obj)
	}

	return obj;
}

function AlertMessage( where, type, title, message, timer ){
	where.find('#AlertMessage').remove();

	var html = '<div class="alert alert-'+type+' alert-dismissible fade in" role="alert" id="AlertMessage"> ';
		html += '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button> ';
		html += '<strong class="title">'+title+'</strong> '+message;
		html += '</div>';

	where.prepend(html);

	if( timer ){
		setTimeout(function(){
			where.find('#AlertMessage').remove();
		}, timer)	
	}
	

	$('#AlertMessage').on('closed.bs.alert', function () {
		
	})	

}

var FormDataChanged = [];

function LoadDataForm( form, data, noclear ){
	// Carrega os dados no form
	if( data ){
		for( var i in data ){
			if ( noclear && form.find('#'+i).val() ) continue  
			form.find('#'+i).val( data[i] );
		}
	}

	/*if(  typeof check_changed === 'string' ){
		var backup = SerializeObject($('#cadastro-cliente').serializeArray());
		FormDataChanged[ check_changed ] = backup;
	}*/
}

function ReloadFormDataChanged( form, check_changed ){
	var data_form = SerializeObject($('#cadastro-cliente').serializeArray());
	FormDataChanged[ check_changed ] = data_form;
}

function CheckFormDataChanged( data_form, backup ){
	console.log( JSON.stringify(data_form) )
	console.log( JSON.stringify(FormDataChanged[backup]) )
	return ( JSON.stringify(data_form) != JSON.stringify(FormDataChanged[backup]) );
}

function ClearFormDataChanged( backup ){
	delete FormDataChanged[backup];
}

// Formato Money BR
function MoneyFormat( vlr, cifrao, ponto ){

	if( cifrao == null ) cifrao = "R$ ";
	if( !ponto ) ponto = ",";
	
	if( vlr ){
		vlr = Number(vlr).toFixed(2);
		var neg = '';
		if( vlr < 0 ) neg = '- '; 
		var regex = /([0-9]+)(\.([0-9]+))*/;
		var str = String( vlr );
		var m = regex.exec(str);
		if( m ){
			
			var right = '00';
			var left = m[1];
			if( m[3] ){
				right = m[3];
			}

			var formated = '';

			var regex = /[0-9]{1,3}/g;
			var f = regex.exec(left);
			formated = f.join('.');

			return neg+""+cifrao+formated+ponto+strpad( right, 2, '0', 'R' );

		}	
	} else {
		return cifrao+"0"+ponto+"00";
	}
}

// Carrega form com o Json passado
function CallForm( json, form, callback, submit ){
	
	
	if( json ) json += "?"+Math.random();

	form.doform({
		action : form.attr('action'),
		data : json,
		loaded : function(){	
			
			form.find("[data-type=telefone]").mask(SPMaskBehavior, spOptions);

			if( callback ) callback();

		},
		submit : function(){

			if( submit ) submit()
			return false;
		},
		classinput : 'form-group',
		block : function(){
			//alert('Bloking')
		},
		unblock : function(){
			//alert('Unbloking')
		}
		
	})

}

// Fun?o geral para Modal
function Modal( title, url, callback, size, id , where ){

	if( !size ) size = 'lg';
	if( !where ) where = $("#modal");

	where.removeClass('bs-example-modal-sm');
	where.removeClass('bs-example-modal-lg');
	where.removeClass('bs-example-modal-md');

	where.find('.modal-dialog').removeClass('modal-lg');
	where.find('.modal-dialog').removeClass('modal-sm');
	where.find('.modal-dialog').removeClass('modal-md');

	where.addClass('bs-example-modal-'+size);
	where.find('.modal-dialog').addClass('modal-'+size);

	keyboard = false;
	if( where.data('keyboard') ){
		keyboard = true;
	}

	// Set ao title do modal
	where.find('.modal-title').html( title );

	if( url ){
		// Carrega o conteudo do modal
		where.find('.modal-body').load(url, function(){
			
			where.find('.modal-save').unbind('click').click(function(){
				where.find('.modal-body form').submit()
			})
			// Abre o modal
			where.modal({	keyboard: keyboard, 
							backdrop: 'static'
						});

			where.on('hide.bs.modal', function (e) {
			  Keyboard_step = 'sell';
			})

			//where.find('.modal-body').append( keyboard )

			// callback padr?
			initJs();

			// Se houver callback... chama
			if( callback ) {
				var func = eval( callback );
				func.apply(this,[id])
			}
		})	
	}
	
}

function ModalConfirm( title, msg, confirm_event, hide_event ){

	confirming = confirm_event;

	$('#modal-confirm .modal-title').html( title )
	$('#modal-confirm .modal-body').html( msg );
	$('#modal-confirm').modal({	backdrop: 'static',
		                        keyboard: true, 
		                        show: true});

	if( confirm_event ){
		$('.btn-confirm').unbind('click').click(function(){
			confirm_event();
			$('.confirm-close').click();
			return false;
		})
	}

	// Ao ocultar o modal...
	$('#modal-confirm').on('hidden.bs.modal', function (e) {
		confirming = false;
		if( hide_event ) hide_event();
	})

}

function ModalSenhaAdm( title, loaded, hide_event ){

	$('#modal-snh-adm .modal-title').html( title )
	//$('#modal-snh-adm .modal-body').html( msg );
	$('#modal-snh-adm').modal({	backdrop: 'static',
		                        keyboard: true, 
		                        show: true});
	// Ao ocultar o modal...
	$('#modal-snh-adm').on('hidden.bs.modal', function (e) {
		if( hide_event ) hide_event();
	}).on('shown.bs.modal', function (e) {
		$('#modal-snh-adm form').find('input:eq(0)').focus();
		loaded()
	})

	$('#modal-snh-adm .modal-save').unbind('click').click(function(){
		$('#modal-snh-adm .modal-body form').submit()
	})
}

function HelperNavBar( where, items ){
	where.html('');
	for( var i in items ){
		where.append("<li ><kbd> "+items[i].tecla+" </kbd> "+items[i].text+" </li>")
	}
}


var SPMaskBehavior = function (val) {
  return val.replace(/\D/g, '').length === 11 ? '(00) 00000-0000' : '(00) 0000-00009';
}, spOptions = {
  onKeyPress: function(val, e, field, options) {
      field.mask(SPMaskBehavior.apply({}, arguments), options);
    }
};


function ConvertMoneytoFloat( text ){
	var text_number = text.replace(/[^0-9\,]/g,'').replace(',','.');
	return Number( text_number );
}

function Notify( text, type ){
	$('.notifications').notify({
      message: { text: text },
      type: type,
      fadeOut: {
        delay: 7000
      }
    }).show();
}


/*function chartLine( where ){
	var chart = new CanvasJS.Chart(where, {
		title: {
			text: "Vendas por período",
			fontSize: 30
		},
		animationEnabled: true,
		axisX: {
			gridColor: "Silver",
			tickColor: "silver",
			valueFormatString: "DD/MMM"
		},
		toolTip: {
			shared: true
		},
		theme: "theme2",
		axisY: {
			gridColor: "Silver",
			tickColor: "silver"
		},
		legend: {
			verticalAlign: "center",
			horizontalAlign: "right"
		},
		data: [
		{
			type: "line",
			showInLegend: true,
			lineThickness: 2,
			name: "Visits",
			markerType: "square",
			color: "#F08080",
			dataPoints: [
			{ x: new Date(2010, 0, 3), y: 650 },
			{ x: new Date(2010, 0, 5), y: 700 },
			{ x: new Date(2010, 0, 7), y: 710 },
			{ x: new Date(2010, 0, 9), y: 658 },
			{ x: new Date(2010, 0, 11), y: 734 },
			{ x: new Date(2010, 0, 13), y: 963 },
			{ x: new Date(2010, 0, 15), y: 847 },
			{ x: new Date(2010, 0, 17), y: 853 },
			{ x: new Date(2010, 0, 19), y: 869 },
			{ x: new Date(2010, 0, 21), y: 943 },
			{ x: new Date(2010, 0, 23), y: 970 }
			]
		},
		{
			type: "line",
			showInLegend: true,
			name: "Unique Visits",
			color: "#20B2AA",
			lineThickness: 2,

			dataPoints: [
			{ x: new Date(2010, 0, 3), y: 510 },
			{ x: new Date(2010, 0, 5), y: 560 },
			{ x: new Date(2010, 0, 7), y: 540 },
			{ x: new Date(2010, 0, 9), y: 558 },
			{ x: new Date(2010, 0, 11), y: 544 },
			{ x: new Date(2010, 0, 13), y: 693 },
			{ x: new Date(2010, 0, 15), y: 657 },
			{ x: new Date(2010, 0, 17), y: 663 },
			{ x: new Date(2010, 0, 19), y: 639 },
			{ x: new Date(2010, 0, 21), y: 673 },
			{ x: new Date(2010, 0, 23), y: 660 }
			]
		}
		],
		legend: {
			cursor: "pointer",
			itemclick: function (e) {
				if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
					e.dataSeries.visible = false;
				}
				else {
					e.dataSeries.visible = true;
				}
				chart.render();
			}
		}
	});

	chart.render();
}*/


function chartline( where, dataChar ){
	new Chartist.Line(where, {
		  labels: dataChar.label,
		  series: dataChar.series
		}, {
		  fullWidth: true,
		  chartPadding: {
		    right: 30,
		    left: -10
		  },
		  showArea: true
		});

}

function chartpizza( where, dataChar ){
	var data = {
	  labels: dataChar.label,
	  series: dataChar.series
	};

	var sum = function(a, b) { return a + b };

	var options = {
	  labelInterpolationFnc: function(value) {
	    return value
	  }
	};

	new Chartist.Pie(where, data, options);

}

function chartbar( where, dataChar  ){
	new Chartist.Bar(where, {
	  labels: dataChar.label,
	  series: dataChar.series
	}, {
	  distributeSeries: true
	});
}

function ExportExcel( data, filename, columns, only ){

	var content = "";
	var lines = [];
	var cols;

	lines.push( columns.join(";") );

	if( only ){

		for( var l in data ){

			cols = [];
			for( var c in only ){
				cols.push(data[l][ only[c] ]);
			}	

			lines.push( cols.join(';') );
			delete(cols);
		}	

	} else {
		for( var l in data ){

			cols = [];
			for( var c in data[l] ){
				cols.push(data[l][c]);
			}	

			lines.push( cols.join(';') );
			delete(cols);
		}		
	}

	

	var content = lines.join("\n");
	//$('#page-content').html( content )
	
	var date = new Date();

	filename += "-"+Today()+".csv";

	var encodedUri = "data:text/csv;charset=utf-8,"+encodeURI(content);
	var link = document.createElement("a");
	link.setAttribute("href", encodedUri);
	link.setAttribute("download", filename);
	document.body.appendChild(link); // Required for FF

	link.click();
}

function Today(){
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth()+1; //January is 0!
	var yyyy = today.getFullYear();

	if(dd<10) {
	    dd='0'+dd
	} 

	if(mm<10) {
	    mm='0'+mm
	} 

	today = yyyy+"-"+mm+'-'+dd;
	return today
}

function ConverteFracao( value ){
	switch( Number(value) ){
		case 1:
			value = "1";
		break;
		case 0.5:
			value = "1/2";
		break;
		case 0.25:
			value = "1/4";
		break;
		case 0.125:
			value = "1/8";
		break;
	}

	return value;
}