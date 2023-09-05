<cfinclude template="includes/session.cfm">
<cfparam name="url.category" default="">
<cfset category = url.category>
<cfscript>
	queryService = new query();
	queryService.setDatasource("fashion");
	queryService.setName("cartegoryResult");
	queryService.addParam(name="slug",value="#category#",cfsqltype="cf_sql_varchar");
	result = queryService.execute(sql="SELECT * FROM category WHERE cat_slug = :slug");
	cartegoryResult = result.getResult();
	getCartegoryInfo = result.getPrefix();
</cfscript>

<cfset category_id = cartegoryResult.id >

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
                            <cfoutput><h1 class="page-header">#cartegoryResult.name#</h1></cfoutput>
							<cftry>
								<cfscript>
									queryService = new query();
									queryService.setDatasource("fashion");
									queryService.setName("productCartegoryResult");
									queryService.addParam(name="catid",value="#category_id#",cfsqltype="CF_SQL_INTEGER");
									result = queryService.execute(sql="SELECT id, category_id, description, name, slug, price, photo FROM products WHERE category_id = :catid");
									productCartegoryResult = result.getResult();
									getProductCartegoryInfo = result.getPrefix();
								</cfscript>
								
								<cfset inc = 3>
								<cfloop query="productCartegoryResult">
									<cfset image = (len(trim(productCartegoryResult.photo)) GT 0) ? 'images/' & productCartegoryResult.photo : 'images/noimage.jpg'>
									<cfset inc = (inc EQ 3) ? 1 : inc + 1>
									<cfif inc eq 1>
										<div class='row'>
									</cfif>
										<div class='col-sm-4'>
											<div class='box box-solid'>
												<div class='box-body prod-body'>
													<cfoutput><img src="#image#" width='100%' height='230px' class='thumbnail'></cfoutput>
													<cfoutput><h5><a href="product.cfm?product=#productCartegoryResult.slug#">#productCartegoryResult.name#</a></h5></cfoutput>
												</div>
												<div class='box-footer'>
													<b>&#36; <cfoutput>#numberFormat(productCartegoryResult.price, 9)#</cfoutput></b>
												</div>
											</div>
										</div>
									<cfif inc eq 3>
										</div>
									</cfif>
								</cfloop>
								<cfif inc eq 1>
									<cfoutput><div class='col-sm-4'></div><div class='col-sm-4'></div></div></cfoutput>
								</cfif>
								<cfif inc eq 2>
									<cfoutput><div class='col-sm-4'></div></div></cfoutput>
								</cfif>

								
							<cfcatch type="database">
								<cfoutput>#cfcatch.message#</cfoutput>
							</cfcatch>
							</cftry>
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