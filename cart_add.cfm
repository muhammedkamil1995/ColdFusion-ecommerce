<cfscript>
    include 'includes/session.cfm'

    id = form.id
    quantity = form.quantity
    output = StructNew()
    output.error = false

    if (structKeyExists(session, "user")) {
        queryService = new query();
        queryService.setDatasource("fashion");
        queryService.setName("cartResult");
        queryService.addParam(name="user_id", value=session.user, cfsqltype="cf_sql_varchar");
        queryService.addParam(name="product_id", value=id, cfsqltype="CF_SQL_INTEGER");
        result = queryService.execute(sql="SELECT *, COUNT(*) AS numrows FROM cart WHERE user_id = :user_id AND product_id = :product_id");
        cartResult = result.getResult();

        // Check the result
        if (cartResult.numrows lt 1) {
            try {
                queryService.addParam(name="user_id", value=session.user, cfsqltype="cf_sql_varchar");
                queryService.addParam(name="product_id", value=id, cfsqltype="CF_SQL_INTEGER");
                queryService.addParam(name="quantity", value=quantity, cfsqltype="CF_SQL_INTEGER");
                result = queryService.execute(sql="INSERT INTO cart (user_id, product_id, quantity) VALUES (:user_id, :product_id, :quantity)");
                insertResult = result.getResult();

                output.message = 'Item added to cart'
            } catch (type database) {
                output.error = true;
                output.message = #cfcatch.message#
            }
        } else {
            output.error = true;
            output.message = 'Product already in cart';
        }
    } else {
        if (!structKeyExists(session, "cart")) {
            session.cart = [];
        }

        exist = [];

        for (row in session.cart) {
            arrayAppend(exist, row.productid);
        }

        if (arrayFind(exist, id)) {
            output.error = true;
            output.message = 'Product already in cart';
        } else {
            data = {};
            data.productid = id;
            data.quantity = quantity;

            if (arrayAppend(session.cart, data)) {
                output.message = 'Item added to cart';
            } else {
                output.error = true;
                output.message = 'Cannot add item to cart';
            }
        }
    }

    WriteOutput(serializeJSON(output));
</cfscript>
