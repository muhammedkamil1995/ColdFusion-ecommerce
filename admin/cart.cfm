<cfinclude template="includes/session.cfm">
<cfset user = {}>

<cfif structKeyExists(url, "user")>
	<cfset userId = url.user>
	<cfquery name="getUserCart" datasource="fashion">
		SELECT * FROM users WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userId#">
	</cfquery>
	<cfset user = #getUserCart#>
</cfif>

<cfinclude template="includes/header.cfm">
<cfoutput>
	<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
		<cfinclude template="includes/navbar.cfm">
		<cfinclude template="includes/menubar.cfm">
		<div class="content-wrapper">
			<section class="content-header">
				<h1>
					#user.firstname# #user.lastname#'s Cart
				</h1>
				<ol class="breadcrumb">
					<li><a href="##"><i class="fa fa-dashboard"></i> Home</a></li>
					<li>Users</li>
					<li class="active">Cart</li>
				</ol>
			</section>
			<section class="content">
				<cfif structKeyExists(session, "error")>
					<div class="alert alert-danger alert-dismissible">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
						<h4><i class="icon fa fa-warning"></i> Error!</h4>
						<output>#session.error#</output>
						<cfset structDelete(session, "error")>
					</div>
				</cfif>
				<cfif structKeyExists(session, "success")>
					<div class="alert alert-success alert-dismissible">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
						<h4><i class="icon fa fa-check"></i> Success!</h4>
						<output>#session.success#</output>
						<cfset structDelete(session, "success")>
					</div>
				</cfif>
				<div class="row">
					<div class="col-xs-12">
						<div class="box">
							<div class="box-header with-border">
								<a href="##addnew" data-toggle="modal" id="add" data-id="#user.id#" class="btn btn-primary btn-sm btn-flat"><i class="fa fa-plus"></i> New</a>
								<a href="users.cfm" class="btn btn-sm btn-primary btn-flat"><i class="fa fa-arrow-left"></i> Users</a>
							</div>
							<div class="box-body">
								<table id="example1" class="table table-bordered">
									<thead>
										<th>Product Name</th>
										<th>Quantity</th>
										<th>Tools</th>
									</thead>
									<tbody>
										<cfquery name="products" datasource="fashion">
											SELECT *, cart.id AS cartid 
											FROM cart 
											LEFT JOIN products ON products.id = cart.product_id 
											WHERE user_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user.id#">
										</cfquery>
										<cfloop query="products">
											<tr>
												<td>#name#</td>
												<td>#quantity#</td>
												<td>
													<button class="btn btn-success btn-sm edit btn-flat" data-id="#cartid#"><i class="fa fa-edit"></i> Edit Quantity</button>
													<button class="btn btn-danger btn-sm delete btn-flat" data-id="#cartid#"><i class="fa fa-trash"></i> Delete</button>
												</td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
		</cfoutput>
		<cfinclude template="includes/footer.cfm">
		<cfinclude template="includes/cart_modal.cfm">
	</div>
	<!-- ./wrapper -->
	<cfinclude template="includes/scripts.cfm">
	<script>
$(function(){
  $(document).on('click', '.edit', function(e){
    e.preventDefault();
    $('#edit').modal('show');
    var id = $(this).data('id');
    getRow(id);
  });

  $(document).on('click', '.delete', function(e){
    e.preventDefault();
    $('#delete').modal('show');
    var id = $(this).data('id');
    getRow(id);
  });

  $('#add').click(function(e){
    e.preventDefault();
    var id = $(this).data('id');
    getProducts(id);
  });

  $("#addnew").on("hidden.bs.modal", function () {
      $('.append_items').remove();
  });

});

function getProducts(id){
  $.ajax({
    type: 'POST',
    url: 'products_all.cfm',
    dataType: 'html',
    success: function(response){
	  console.log(response)
      $('#product').append(response);
      $('.userid').val(id);
    }
  });
}

function getRow(id){
  $.ajax({
    type: 'POST',
    url: 'cart_row.cfm',
    data: {id:id},
    dataType: 'json',
    success: function(response){
		console.log(response[0].cartid)
      $('.cartid').val(response[0].cartid);
      $('.userid').val(response[0].user_id);
      $('.productname').html(response[0].name);
      $('#edit_quantity').val(response[0].quantity);
    }
  });
}
</script>
</body>
</html>
