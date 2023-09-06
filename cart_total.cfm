<cfscript>
    include 'includes/session.cfm'
	
	total = 0

    if (structKeyExists(session, "user")) {
		try {
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("fetchCartTotalResult");
			queryService.addParam(name="user_id", value=#session.user#, cfsqltype="CF_SQL_INTEGER");
			result = queryService.execute(sql="SELECT * FROM cart LEFT JOIN products on products.id=cart.product_id WHERE user_id=:user_id");
			fetchCartTotalResult = result.getResult();
			fetchCartTotalInfo = result.getPrefix();

			if( fetchCartTotalInfo.recordcount gt 0 ) {
				for( row in fetchCartTotalResult){
					subtotal = row['price'] * row['quantity'];
					total += subtotal;
				}
			}
			
		} catch(type database){
            
		}
        
    }

    WriteOutput(serializeJSON(total));
</cfscript>