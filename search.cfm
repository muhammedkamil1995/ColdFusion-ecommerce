<cfinclude template="includes/session.cfm">
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
				<cfscript>
					if( CGI.REQUEST_METHOD EQ "POST" ) {
						search_param = form.keyword
						queryService = new query();
						queryService.setDatasource("fashion");
						queryService.setName("productparamResult");
						queryService.addParam(name="keyword",value="#search_param#",cfsqltype="CF_SQL_VARCHAR");
						result = queryService.execute(sql="SELECT COUNT(*) AS numrows FROM products WHERE name LIKE :keyword");
						productparamResult = result.getResult();
						getProductserchInfo = result.getPrefix();

						if(productparamResult.numrows lt 1) {
							WriteOutput('<h1 class="page-header">No results found for <i>#search_param#</i></h1>')
						} else {
							WriteOutput('<h1 class="page-header">Search results for <i>#search_param#</i></h1>')
						}

						
						try {
							inc = 3
							queryService.setName("productserchResult");
							queryService.addParam(name="keyword",value="#search_param#",cfsqltype="CF_SQL_VARCHAR");
							result = queryService.execute(sql="SELECT * FROM products WHERE name LIKE :keyword");
							productserchResult = result.getResult();
							getProductserchInfo = result.getPrefix();

							for(row in productserchResult) {
								highlighted = reReplaceNoCase(#search_param#, "LOGINID=[^&]+&?", "")
								image = (len(trim(row.photo)) GT 0) ? 'images/' & row.photo : 'images/profile.jpg'
								inc = (inc EQ 3) ? 1 : inc + 1
								if(inc == 1)  WriteOutput("<div class='row'>");
								WriteOutput("
									<div class='col-sm-4'>
										<div class='box box-solid'>
											<div class='box-body prod-body'>
												<img src='#image#' width='100%' height='230px' class='thumbnail'>
												<h5><a href='product.cfm?product=#row.slug#'>#highlighted#</a></h5>
											</div>
											<div class='box-footer'>
												<b>&##36; #numberFormat(row['price'], 9)#</b>
											</div>
										</div>
									</div>
								")
								if(inc EQ 3) WriteOutput("</div>")
							}
							if(inc EQ 1) WriteOutput("<div class='col-sm-4'></div><div class='col-sm-4'></div></div>") 
							if(inc EQ 2) WriteOutput("<div class='col-sm-4'></div></div>")
						}
						catch(type database) {
							WriteOutput(#cfcatch.message#)
						}
					} else {
						WriteOutput('<h1 class="page-header">No results found. <i>Nothing to search</i></h1>')
					}
				</cfscript>

	        	</div>
	        	<div class="col-sm-3">
	        		<cfinclude template="includes/sidebar.cfm">
	        	</div>
	        </div>
	      </section>
	     
	    </div>
	  </div>
  
  	<cfinclude template="includes/footer.cfm">
</div>

<cfinclude template="includes/scripts.cfm">
</body>
</html>