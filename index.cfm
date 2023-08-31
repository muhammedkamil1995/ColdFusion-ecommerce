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
                            <cfoutput>
                                <cfif structKeyExists(session, "error")>
                                    <div class="alert alert-danger">
                                        #session.error#
                                    </div>
                                    <cfset structDelete(session, "error")>
                                </cfif>
                            </cfoutput>
                            <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                                <ol class="carousel-indicators">
                                    <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                                    <li data-target="#carousel-example-generic" data-slide-to="1" class=""></li>
                                    <li data-target="#carousel-example-generic" data-slide-to="2" class=""></li>
                                </ol>
                                <div class="carousel-inner">
                                    <div class="item active">
                                        <img src="images/banners1.png" alt="First slide">
                                    </div>
                                    <div class="item">
                                        <img src="images/banners2.png" alt="Second slide">
                                    </div>
                                    <div class="item">
                                        <img src="images/banners3.png" alt="Third slide">
                                    </div>
                                </div>
                                <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
                                    <span class="fa fa-angle-left"></span>
                                </a>
                                <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
                                    <span class="fa fa-angle-right"></span>
                                </a>
                            </div>
                                
                            <h2>Monthly Top Sellers</h2>
                            <cfset now = dateFormat(now(), 'mm')>
                            <cftry>
                                <cfquery name="getTopSellers" datasource="fashion">
                                    SELECT *, SUM(quantity) AS total_qty FROM details
                                    LEFT JOIN sales ON sales.id = details.sales_id
                                    LEFT JOIN products ON products.id = details.product_id
                                    WHERE MONTH(sales_date) = '#now#'
                                    GROUP BY details.product_id
                                    ORDER BY total_qty DESC
                                    LIMIT 6
                                </cfquery>
                                <cfset inc = 3>
                                <cfloop query="getTopSellers">
                                    <cfset image = (not isEmpty(photo)) ? 'images/' & photo : 'images/noimage.jpg'>
                                    <cfset inc = (inc eq 3) ? 1 : inc + 1>
                                    <cfif inc eq 1>
                                        <div class="row">
                                    </cfif>
                                    <div class="col-sm-4">
                                        <div class="box box-solid">
                                            <div class="box-body prod-body">
                                                <img src="#image#" width="100%" height="230px" class="thumbnail">
                                                <cfoutput><h5><a href="product.cfm?product=#slug#">#name#</a></h5></cfoutput>
                                            </div>
                                            <div class="box-footer">
                                                <b>&#36; <cfoutput>#numberFormat(price, '9.99')#</cfoutput></b>
                                            </div>
                                        </div>
                                    </div>
                                    <cfif inc eq 3>
                                        </div>
                                    </cfif>
                                </cfloop>
                                <cfif inc eq 1>
                                    <div class="col-sm-4"></div>
                                    <div class="col-sm-4"></div>
                                </cfif>
                                <cfif inc eq 2>
                                    <div class="col-sm-4"></div>
                                </cfif>
                                <cfcatch type="any">
                                    <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
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
