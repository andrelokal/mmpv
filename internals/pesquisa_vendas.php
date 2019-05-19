<div class="row">
	<div class="col-md-6">
	</div>
	<div class="col-md-6">
		<div class="form-inline">
			<div class="form-group">
				<label>Data da Venda</label>
				<div class="input-group ">					
					<input type="text" class="form-control" placeholder="Data" id='date-modal' value="<?=date('d/m/Y')?>" data-type='date'>
			   	</div>
			</div>

			<div class="form-group">
				<button class="btn btn-primary pesq-modal" type="button">Buscar</button>
			</div>

			<!-- <div class="form-group">
				<label>Palavra Chave</label>
				<div class="input-group ">
			      	<input type="text" class="form-control" placeholder="Pesquisar..." id='pesquisa-modal'>
			  		<span class="input-group-btn">
			        	<button class="btn btn-primary pesq-modal" type="button">Buscar</button>
			      	</span>
			   	</div>
			</div> -->
		</div>

	</div>
</div>
<div class="clearfix">&nbsp;</div>
<div class="row" style="height: 100%">
	<div class="col-md-12">
			<table class="table table-striped table-hover table-bordered table-condensed" id='datagrid-modal' style="width: 100%">

			</table>
	</div>	
</div>

<script>	

	$(function(){
		$('.btn.pesq-modal').click(function(){
			LoadGridPesquisaVenda()
		})	
		$('#pesquisa-modal, #date-modal').keydown(function(e){
			if( e.which == 13 ){
				LoadGridPesquisaVenda()
				return false;
			}
		})
		//setTimeout(function(){ $('#pesquisa-modal').focus()},500);
	})
	

	var DataTablePesqPed = null;
	var vendaPesq = new $PHP('sale_ctl');
		vendaPesq.loaded = LoadGridPesquisaVenda;


	function LoadGridPesquisaVenda(){
		
		$('#datagrid-modal').html( '' );
		vendaPesq.filter = {"data": $('#date-modal').val() };
		vendaPesq.call('selectAll',[0,15],function( ret ){
			if( !ret.success ){
				$('#datagrid-modal').html( ret.message );
			} else {

				DataTablePesqPed = $('#datagrid-modal').DataTable({
					"data" : vendaPesq.data,
					paging:  false,
					searching: false,
				    lengthChange : false,
				    rowId: 'id',
			        columns: [
			            { data: "id", title: "ID" , width: "10%"},
			            {
			                data : "total",
			                sortable: false,
			                title: "Valor" , 
			                width: "50%",
			                "render": function ( data, type, full, meta ) {
			                	return "<span class='money'><b>"+MoneyFormat(full.total)+"</b></span>" ;
			                }
			            },
			            { data: "data", title: "Data" , width: "20%"},
			            {
			                data : "id",
			                sortable: false,
			                "render": function ( data, type, full, meta ) {

			                	html = "<div class='btn-group ' role='group' aria-label=''>"
			                	html += "<button class='btn btn-danger btn-xs cancel' type='button' codigo='"+full.id+"' data-toggle='tooltip' data-placement='top' title='Somente Administrador'>Cancelar <span class='glyphicon glyphicon-lock'></span></button>";
			                	html += "</div>";

			                	return html;
			                }
			            }
			        ],
	        		destroy: true
			    }).on( 'draw', function() {
				    initJs();
				    ActiveButtons_pv()
				    
				});

				ActiveButtons_pv()

			    
			}
		})
	}

	function ActiveButtons_pv(){
		$('#datagrid-modal .btn').unbind('click').click(function(){
    		var id = $(this).parents('tr:eq(0)').attr('id')
    		
    		if( $(this).hasClass('cancel') ){
	    		CancelarVenda( id )
	    	}
	    	
	    	return false;
	    })
	}

	function CancelarVenda( id ){
		
		ModalSenhaAdm( 'Confirmar Cancelamento', function(){

			var formElement = $('#modal-snh-adm .modal-body form');
			formElement.attr('action','');
			CallForm(null, formElement, function(){

				// Ao criar form

			}, function( ret ){
				vendaPesq.sendException = ['obj','data','msg','sendException'];
				// Submit form
				vendaPesq.call('cancel',[id, formElement.find('#password').val()],function( ret ){
					if(ret.success){

						formElement.find('#password').val('')

						LoadGridPesquisaVenda()
						$('#modal-snh-adm .modal-close').click();
						AlertMessage( $('#datagrid-modal').parent(), 'success', "Sucesso!", "Venda cancelada com sucesso!", 3000 );

					} else {

						AlertMessage( formElement, 'warning', "Erro!", ret.message, 3000 );				

					}
				})

			})

		}, function( ret ){
			
			// Ao fechar modal

		})

	}

</script>