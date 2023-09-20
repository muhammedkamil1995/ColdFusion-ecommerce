<cfscript>
	include 'includes/session.cfm';

	if ( CGI.REQUEST_METHOD EQ "GET" ) {
		if ( structKeyExists(form, 'pay') ) {
			payid = form.pay
			date = LSDateFormat(now(), 'yyyy-mm-dd')

			
			try {
				queryService = new query();
                queryService.setDatasource("fashion");
                queryService.setName("insertSales");
                queryService.addParam(name="user_id",value="#getUserResult.id#",cfsqltype="CF_SQL_INTEGER");
                queryService.addParam(name="pay_id",value="#payid#",cfsqltype="CF_SQL_INTEGER");
                queryService.addParam(name="sales_date",value="#date#",cfsqltype="cf_sql_date");
                result = queryService.execute(sql="INSERT INTO sales (user_id, pay_id, sales_date) VALUES (:user_id, :pay_id, :sales_date)");
                insertSales = result.getResult();
                insertSalesMetaInfo = result.getPrefix();

				sales_id = insertSalesMetaInfo.GENERATED_KEY

				
				try {
					queryService.setName("selectCart");
					queryService.addParam(name="user_id",value="#getUserResult.id#",cfsqltype="CF_SQL_INTEGER");
					result = queryService.execute(sql="SELECT * FROM cart LEFT JOIN products ON products.id=cart.product_id WHERE user_id=:user_id");
					selectCart = result.getResult();
					selectCartMetaInfo = result.getPrefix();

					for ( row in selectCart ) {
						queryService.setName("insertCartDetails");
						queryService.addParam(name="sales_id",value="#sales_id#",cfsqltype="CF_SQL_INTEGER");
						queryService.addParam(name="product_id",value="#row.product_id#",cfsqltype="CF_SQL_INTEGER");
						queryService.addParam(name="quantity",value="#row.quantity#",cfsqltype="CF_SQL_INTEGER");
						result = queryService.execute(sql="INSERT INTO details (sales_id, product_id, quantity) VALUES (:sales_id, :product_id, :quantity)");
						insertCartDetails = result.getResult();
						insertCartDetailsMetaInfo = result.getPrefix();
					}

					queryService.setName("deleteCartDetails");
					queryService.addParam(name="user_id",value="#getUserResult.id#",cfsqltype="CF_SQL_INTEGER");
					result = queryService.execute(sql="DELETE FROM cart WHERE user_id=:user_id");
					deleteCartDetails = result.getResult();
					deleteCartDetailsMetaInfo = result.getPrefix();

					session.success = 'Transaction successful. Thank you.';
				}
				catch(type variable) {
					session.error = 'Error while processing transaction. Try again.';
				}
				
				
			}
			catch(type variable) {
				session.error = 'Error while processing sales. Try again.';
			}

			location(url='profile.cfm');
		}
	}
</cfscript>