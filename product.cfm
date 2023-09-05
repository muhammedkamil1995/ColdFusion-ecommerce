<cfinclude template="includes/session.cfm">
<cfparam name="url.category" default="">
<cfset product = url.product>
<cfscript>
	queryService = new query();
	queryService.setDatasource("fashion");
	queryService.setName("productResult");
	queryService.addParam(name="slug",value="#product#",cfsqltype="cf_sql_varchar");
	result = queryService.execute(sql="SELECT *, p.name AS prodname, c.name AS catname, 
			p.id AS prodid FROM products p
			LEFT JOIN category c ON c.id=p.category_id WHERE slug = :slug");
	productResult = result.getResult();
    // p.category_id, p.description, p.slug, p.price, p.photo, p.date_view, c.cat_slug

    now = LSDateFormat(now(), 'yyyy-mm-dd');
    if(productResult.date_view == now){
        queryService.addParam(name="id",value="#productResult.prodid#",cfsqltype="CF_SQL_INTEGER");
		result = queryService.execute(sql="UPDATE products SET counter=counter+1 WHERE id=:id");
	}else{
        queryService.addParam(name="id",value="#productResult.prodid#",cfsqltype="CF_SQL_INTEGER");
        queryService.addParam(name="now",value="#now#",cfsqltype="CF_SQL_DATE");
		result = queryService.execute(sql="UPDATE products SET counter=1, date_view=:now WHERE id=:id");
	}
</cfscript>

<cfinclude template="includes/header.cfm">

<body class="hold-transition skin-blue layout-top-nav">
    <script>
    (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s);
        js.id = id;
        js.src = 'https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.12';
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
    </script>
    <div class="wrapper">

        <cfinclude template="includes/navbar.cfm">

        <div class="content-wrapper">
            <div class="container">

                <!-- Main content -->
                <section class="content">
                    <div class="row">
                        <div class="col-sm-9">
                            <div class="callout" id="callout" style="display:none">
                                <button type="button" class="close"><span aria-hidden="true">&times;</span></button>
                                <span class="message"></span>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <cfset image = (len(trim(productResult.photo)) GT 0) ? 'images/' & productResult.photo : 'images/noimage.jpg'>
                                    <cfoutput><img src="#image#"
                                        width="100%" class="zoom"
                                        data-magnify-src="images/large-#image#"></cfoutput>
                                    <br><br>
                                    <form class="form-inline" id="productForm">
                                        <div class="form-group">
                                            <div class="input-group col-sm-5">

                                                <span class="input-group-btn">
                                                    <button type="button" id="minus"
                                                        class="btn btn-default btn-flat btn-lg"><i
                                                            class="fa fa-minus"></i></button>
                                                </span>
                                                <input type="text" name="quantity" id="quantity"
                                                    class="form-control input-lg" value="1">
                                                <span class="input-group-btn">
                                                    <button type="button" id="add"
                                                        class="btn btn-default btn-flat btn-lg"><i
                                                            class="fa fa-plus"></i>
                                                    </button>
                                                </span>
                                                <cfoutput><input type="hidden" value="#productResult.prodid#"
                                                    name="id"></cfoutput>
                                            </div>
                                            <button type="submit" class="btn btn-primary btn-lg btn-flat"><i
                                                    class="fa fa-shopping-cart"></i> Add to Cart</button>
                                        </div>
                                    </form>
                                </div>
                                <div class="col-sm-6">
                                    <h1 class="page-header"><cfoutput>#productResult.prodname#</cfoutput></h1>
                                    <h3><b>&#36; <cfoutput>#numberFormat(productResult.price, 9)#</cfoutput></b></h3>
                                    <p><b>Category:</b> <cfoutput><a
                                            href="category.cfm?category=#productResult.cat_slug#">#productResult.catname#</a></cfoutput>
                                    </p>
                                    <p><b>Description:</b></p>
                                    <p><cfoutput>#productResult.description#</cfoutput></p>
                                </div>
                            </div>
                            <br>
                            <cfoutput>
                            <div class="fb-comments"
                                data-href="http://localhost/ecommerce/product.php?product=#product#"
                                data-numposts="10" width="100%"></div></cfoutput>
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
    <script>
    $(function() {
        $('#add').click(function(e) {
            e.preventDefault();
            var quantity = $('#quantity').val();
            quantity++;
            $('#quantity').val(quantity);
        });
        $('#minus').click(function(e) {
            e.preventDefault();
            var quantity = $('#quantity').val();
            if (quantity > 1) {
                quantity--;
            }
            $('#quantity').val(quantity);
        });

    });
    </script>
</body>

</html>