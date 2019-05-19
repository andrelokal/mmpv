<div class="row">
<div class="col-md-6">
		
</div>
<div class="col-md-6">
	<div class="input-group ">
      	<input type="text" class="form-control" placeholder="Pesquisar..." id='pesquisa-modal'>
  		<span class="input-group-btn">
        	<button class="btn btn-primary pesq-modal" type="button">Buscar</button>
      	</span>
   	</div><!-- /input-group -->
	
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
		$('#pesquisa-modal').val( $('#pesquisar-produto').val() );
		$('#pesquisar-produto').val('')
		$('.btn.pesq-modal').click(function(){
			LoadGridPesquisa()
		})	
		$('#pesquisa-modal').keydown(function(e){
			if( e.which == 13 ){
				LoadGridPesquisa()
				return false;
			}
		})
		setTimeout(function(){ $('#pesquisa-modal').focus()},500);
	})
	

	var DataTablePesq = null;
	var prodPesq = new $PHP('produto_ctl');
		prodPesq.loaded = LoadGridPesquisa;

	function LoadGridPesquisa(){
		
		$('#datagrid-modal').html( '' );
		prodPesq.search = $('#pesquisa-modal').val();
		prodPesq.call('selectAll',[0,10],function( ret ){
			if( !ret.success ){
				$('#datagrid-modal').html( ret.message );
			} else {

				DataTablePesq = $('#datagrid-modal')
				.on( 'init.dt', function () {
        			
					$('#datagrid-modal').keytable({
						limit : 5
					})
					.off('escapeUp').on( 'escapeUp',{}, function(){
						$('#datagrid-modal').keytable().deSelectAll();
						$('#pesquisa-modal').focus()
					})
					.off('delete').on('delete',{},function( trAtual ){
						
					})
					.off('blur').on('blur',{},function(){
						 
					})
					.off('focus').on('focus',{},function( table ){
						table.addClass('focused');
						Keyboard_step = 'keytable-pesq';
					});	

					ActiveButtons_pesq();

    			}).DataTable({
					"data" : prodPesq.data,
					paging:  false,
					searching: false,
				    lengthChange : false,
				    rowId: 'id',
			        columns: [
			            { data: "id", title: "ID" , width: "10%"},
			            { data: "codigo", title: "Código" , width: "10%"},
			            { data: "categoria", title: "Categoria", width: "20%" },
			            { data: "nome", title: "Produto" , width: "25%"},
			            {
			                data : "valor",
			                sortable: false,
			                title: "Valor" , 
			                width: "10%",
			                "render": function ( data, type, full, meta ) {
			                	return "<span class='money'><b>"+MoneyFormat(full.valor)+"</b></span>" ;
			                }
			            },
			            //{ data: "tem_estoque", title: "Est." , width: "10%"},
			            { data: "estoque", title: "Qnt." , width: "10%"},
			            {
			                data : "id",
			                sortable: false,
			                "render": function ( data, type, full, meta ) {

			                	html = "<div class='btn-group ' role='group' aria-label=''>";
			                	html += "<button class='btn btn-primary btn-xs select' type='button' codigo='"+full.codigo+"'>Selecionar</button>";
			                	html += "</div>";

			                	return html;
			                }
			            }
			        ],
	        		destroy: true
			    }).on( 'draw', function(){
				    initJs();
				    ActiveButtons_pesq();				    
				})

			    
			    
			}
		})
	}


	function ActiveButtons_pesq(){
		$('#datagrid-modal .btn').unbind('click').click(function(){
    		var id = $(this).parents('tr:eq(0)').attr('id')
    		var codigo = $(this).attr('codigo')

	    	if( $(this).hasClass('select') ){
	    		ProdutoPorCodigo( codigo )
	    	}
	    	
	    	return false;
	    })
	}

</script>