<cfscript>
    include 'includes/session.cfm';

    if (structKeyExists(form, "delete")) {
        id = form.id;

        try {
           
            queryService = new query();
            queryService.setDatasource("fashion");
            queryService.setSql("DELETE FROM products WHERE id = :id");
            queryService.addParam(name="id", value=id, cfsqltype="cf_sql_integer");
            result = queryService.execute();
          

            if (result) {
                session.success = "Product deleted successfully";
            }
            else {
                session.error = "Failed to delete product";
            }
        }
        catch (any e) {
            session.error = e.getMessage();
        }
    }
    else {
        session.error = "Select a product to delete first";
    }

    location(url="products.cfm");
</cfscript>
