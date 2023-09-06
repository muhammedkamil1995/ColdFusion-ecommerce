<cfscript>
    include 'includes/session.cfm'

    output = { "error": false };

	id = form.id

    if (structKeyExists(session, "user")) {
		try {
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("deletedCartResult");
			queryService.addParam(name="id", value=#id#, cfsqltype="CF_SQL_INTEGER");
			result = queryService.execute(sql="DELETE FROM cart WHERE id=:id");
			getDeletedCartInfo = result.getPrefix();
			if (getDeletedCartInfo.recordcount eq 1) {
                output.message = "Cart Successfully Deleted";
            } else {
                output.error = true;
                output.message = "Error deleting item from cart";
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
					structDelete(session.cart, i);
					output['message'] = 'Cart Successfully Deleted';
				}
			}
        } else {
            output.error = true;
            output.message = "Cart does not exist or is not an array";
        }
    }

    WriteOutput(serializeJSON(output));
</cfscript>