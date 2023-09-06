<cfscript>
    include 'includes/session.cfm'

    output = { "error": false };

	id = form.id
	qty = form.qty

    if (structKeyExists(session, "user")) {
		try {
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("updatedCartResult");
			queryService.addParam(name="id", value=#id#, cfsqltype="CF_SQL_INTEGER");
			queryService.addParam(name="quantity", value=#qty#, cfsqltype="CF_SQL_INTEGER");
			result = queryService.execute(sql="UPDATE cart SET quantity=:quantity WHERE id=:id");
			getUpdatedCartInfo = result.getPrefix();
			if (getUpdatedCartInfo.recordcount eq 1) {
                output.message = "Cart Successfully Updated";
            } else {
                output.error = true;
                output.message = "Error Updating item from cart";
            }
		} catch(type database){
			output.error = true;
            output.message = #cfcatch.message#
		}
        
    } else {

        if (isArray(session.cart)) {
            for(i = 1; i <= arrayLen(session.cart); i++) {
				row = session.cart[i];
				if(row['productid'] EQ id){
					session.cart[i].quantity = qty;
					output['message'] = 'Cart Successfully Updated';
				}
			}
        } else {
            output.error = true;
            output.message = "Cart does not exist";
        }
    }

    WriteOutput(serializeJSON(output));
</cfscript>