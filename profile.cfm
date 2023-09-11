<cfinclude template="includes/session.cfm"> 

<cfif not structKeyExists(session, "user")>
    <cflocation url="index.cfm">
</cfif>

<cfinclude template="includes/header.cfm">

<body class="hold-transition skin-blue layout-top-nav">
<div class="wrapper">

	<cfinclude template="includes/navbar.cfm">
	 
	  <div class="content-wrapper">
	    <div class="container">

	      <!-- Main content -->
	      <section class="content">
	        <div class="row">
	        	<div class="col-sm-9">

					 <cfoutput>
      					<cfif structKeyExists(session, "error")>
          					<div class="callout callout-danger text-center">
           						#session.error#
          					</div>
          				<cfset structDelete(session, "error")>
      				 	</cfif>

      					<cfif structKeyExists(session, "success")>
          					<div class="callout callout-success text-center">
            					#session.success#
          				</div>
          				<cfset structDelete(session, "success")>
      					</cfif>
    				</cfoutput>
	        		
	        		<div class="box box-solid">
	        			<div class="box-body">
	        				<div class="col-sm-3">
    							<cfset userPhoto = (len(trim(getUserResult.photo)) GT 0) ? 'images/' & getUserResult.photo : 'images/profile.jpg'>
    							<cfoutput><img src="#userPhoto#" width="100%"></cfoutput>
							</div>

	        				<div class="col-sm-9">
	        					<div class="row">
	        						<div class="col-sm-3">
	        							<h4>Name:</h4>
	        							<h4>Email:</h4>
	        							<h4>Contact Info:</h4>
	        							<h4>Address:</h4>
	        							<h4>Member Since:</h4>
	        						</div>
	        						<div class="col-sm-9">
    									<cfoutput>
										<h4>#getUserResult.firstname# #getUserResult.lastname#
											<span class="pull-right">
												<a href="##edit" class="btn btn-success btn-flat btn-sm" data-toggle="modal"><i class="fa fa-edit"></i> Edit</a>
											</span>
										</h4>
   										 <h4>#getUserResult.email#</h4>
    									 <h4>#(len(getUserResult.contact_info) gt 0 ) ? getUserResult.contact_info : 'N/a'#</h4>
    									 <h4>#( len(getUserResult.address) gt 0 ) ? getUserResult.address : 'N/a'#</h4>
    									 <h4>#dateFormat(getUserResult.created_on, 'M d, Y')#</h4>
										 </cfoutput>
									</div>

	        					</div>
	        				</div>
	        			</div>
	        		</div>
	        		<div class="box box-solid">
	        			<div class="box-header with-border">
	        				<h4 class="box-title"><i class="fa fa-calendar"></i> <b>Transaction History</b></h4>
	        			</div>
	        			<div class="box-body">
	        				<table class="table table-bordered" id="example1">
	        					<thead>
	        						<th class="hidden"></th>
	        						<th>Date</th>
	        						<th>Transaction#</th>
	        						<th>Amount</th>
	        						<th>Full Details</th>
	        					</thead>
	        					<tbody>
	        					

								<cftry>
    								<cfquery name="getSales" datasource="fashion">
        							SELECT * FROM sales WHERE user_id = #session.user# ORDER BY sales_date DESC
    							</cfquery>

    							<table>
        							<tr>
            							<th class="hidden"></th>
            							<th>Date</th>
           								<th>Pay ID</th>
            							<th>Total</th>
            							<th></th>
        							</tr>

        						<cfloop query="getSales">
            						<cfset total = 0>
            						<cfset salesDate = dateFormat(getSales.sales_date, 'M d, Y')>

            						<cfquery name="getSaleDetails" datasource="fashion">
                						SELECT * FROM details
                						LEFT JOIN products ON products.id = details.product_id
                						WHERE sales_id = #getSales.id#
            						</cfquery>

            						<cfloop query="getSaleDetails">
                						<cfset subtotal = getSaleDetails.price * getSaleDetails.quantity>
                						<cfset total += subtotal>
            						</cfloop>

            							<tr>
                							<td class="hidden"></td>
               								<cfoutput><td>#salesDate#</td></cfoutput>
                							<cfoutput><td>#getSales.pay_id#</td></cfoutput>
                							<cfoutput><td>&##36; #numberFormat(total, '9.99')#</td></cfoutput>
                							<cfoutput><td><button class='btn btn-sm btn-flat btn-info transact' data-id='#getSales.id#'><i class='fa fa-search'></i> View</button></td></cfoutput>
            							</tr>
        							</cfloop>
    							</table>
    
    							<cfcatch type="any">
       								 <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
    							</cfcatch>
								</cftry>

							

	        					</tbody>
	        				</table>
	        			</div>
	        		</div>
	        	</div>
	        	<div class="col-sm-3">
					<cfinclude template="includes/sidebar.cfm">	
	        	</div>
	        </div>
	      </section>
	     
	    </div>
	  </div>

	<cfinclude template="includes/footer.cfm">	
	<cfinclude template="includes/profile_modal.cfm">
  	
</div>

<cfinclude template="includes/scripts.cfm">
<script>
$(function(){
	$(document).on('click', '.transact', function(e){
		e.preventDefault();
		$('#transaction').modal('show');
		var id = $(this).data('id');
		$.ajax({
			type: 'POST',
			url: 'transaction.cfm',
			data: {id:id},
			dataType: 'json',
			success:function(response){
				$('#date').html(response.date);
				$('#transid').html(response.transaction);
				$('#detail').prepend(response.list);
				$('#total').html(response.total);
			}
		});
	});

	$("#transaction").on("hidden.bs.modal", function () {
	    $('.prepend_items').remove();
	});
});
</script>
</body>
</html>