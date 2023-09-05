<cfscript>
    include 'includes/session.cfm'

    output = StructNew()
    output.list = ''
    output.count = 0



    if (structKeyExists(session, "user")) {
		try {
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("fetchResult");
			queryService.addParam(name="user_id", value=session.user, cfsqltype="cf_sql_varchar");
			result = queryService.execute(sql="SELECT *, products.name AS prodname, category.name AS catname FROM cart LEFT JOIN products ON products.id=cart.product_id LEFT JOIN category ON category.id=products.category_id WHERE user_id=:user_id");
			fetchResult = result.getResult();

			for(row in fetchResult) {
				output['count']++
				image = (len(trim(row.photo)) GT 0) ? 'images/' & row.photo : 'images/noimage.jpg'
				// productname = (len(row['prodname']) gt 30) ? substr_replace(row['prodname'], '...', 27) : row['prodname']
				productname = (len(row.prodname) GT 30) ? replace(mid(row.prodname, 1, 27), " ", "&nbsp;") & "..." : row.prodname

				output['list'] &= "
						<li>
							<a href='product.cfm?product=#row['slug']#'>
								<div class='pull-left'>
									<img src='#image#' class='thumbnail' alt='User Image'>
								</div>
								<h4>
									<b>#row['catname']#</b>
									<small>&times; #row['quantity']#</small>
								</h4>
								<p>#productname#</p>
							</a>
						</li>
					";
			}
		} catch(type database){
			output.error = true;
            output.message = #cfcatch.message#
		}
        
    } else {
        if (!structKeyExists(session, "cart")) {
            session.cart = [];
        }

		arrayLen(session.cart) == 0

		if(arrayLen(session.cart) eq  0){
			output['count'] = 0;
		} else {
			for(row in session.cart) {
				output['count']++;
				queryService = new query();
				queryService.setDatasource("fashion");
				queryService.setName("productResult");
				queryService.addParam(name="id", value=#row.productid#, cfsqltype="cf_sql_varchar");
				result = queryService.execute(sql="SELECT *, products.name AS prodname, category.name AS catname FROM products LEFT JOIN category ON category.id=products.category_id WHERE products.id=:id");
				productResult = result.getResult();

				image = (len(trim(productResult.photo)) GT 0) ? 'images/' & productResult.photo : 'images/noimage.jpg'

				output['list'] &= "
					<li>
						<a href='product.cfm?product=#productResult['slug']#'>
							<div class='pull-left'>
								<img src='#image#' class='img-circle' alt='User Image'>
							</div>
							<h4>
		                        <b>#productResult['catname']#</b>
		                        <small>&times; #$row['quantity']#</small>
		                    </h4>
		                    <p>#productResult['prodname']#</p>
						</a>
					</li>
				";
			}
		}
    }

    WriteOutput(serializeJSON(output));
</cfscript>

