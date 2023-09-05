<cfinclude template="includes/session.cfm">

<cfset output = "">
<cfset total = 0>

<cfif structKeyExists(session, "user")>
    <cfif structKeyExists(session, "cart")>
        <cfloop array="#session.cart#" index="row">
			<cfscript>
				queryService = new query();
				queryService.setDatasource("fashion");
				queryService.setName("loginUser");
				queryService.addParam(name="user_id",value="#session.user#",cfsqltype="cf_sql_varchar");
				queryService.addParam(name="product_id",value="#row.productid#",cfsqltype="cf_sql_varchar");
				result = queryService.execute(sql="SELECT *, COUNT(*) AS numrows FROM cart WHERE user_id=:user_id AND product_id=:product_id");
				cartResult = result.getResult();
				getCartInfo = result.getPrefix();
			</cfscript>
            
            <cfif getCartInfo.recordcount LT 1>
				<cfscript>
					queryService = new query();
					queryService.setDatasource("fashion");
					queryService.setName("insertCart");
					queryService.addParam(name="user_id",value="#session.user#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="product_id",value="#row.productid#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="quantity",value="#row.quantity#",cfsqltype="cf_sql_varchar");
					result = queryService.execute(sql="INSERT INTO cart (user_id, product_id, quantity) VALUES (:user_id, :product_id, :quantity)");
					insertcartResult = result.getResult();
					getCartInfo = result.getPrefix();
				</cfscript>
            <cfelse>
				<cfscript>
					queryService = new query();
					queryService.setDatasource("fashion");
					queryService.setName("updateCart");
					queryService.addParam(name="user_id",value="#session.user#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="product_id",value="#row.productid#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="quantity",value="#row.quantity#",cfsqltype="cf_sql_varchar");
					result = queryService.execute(sql="UPDATE cart SET quantity=:quantity WHERE user_id=:user_id AND product_id=:product_id");
					updatecartResult = result.getResult();
					getUpdateCartInfo = result.getPrefix();
				</cfscript>
            </cfif>
        </cfloop>
        <cfset structDelete(session, "cart")>
    </cfif>

    <cftry>
		<cfscript>
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("loginUser");
			queryService.addParam(name="user",value="#session.user#",cfsqltype="cf_sql_varchar");
			result = queryService.execute(sql="SELECT *, cart.id AS cartid FROM cart LEFT JOIN products ON products.id=cart.product_id WHERE user_id=:user");
			selectResult = result.getResult();
			getSelectCartInfo = result.getPrefix();
		</cfscript>
        <cfloop query="selectResult">
            <cfset image = (len(trim(selectResult.photo)) GT 0) ? 'images/' & selectResult.photo : 'images/noimage.jpg'>
            <cfset subtotal = selectResult.price * selectResult.quantity>
            <cfset total = total + subtotal>
            <cfset output &= "
                <tr>
                    <td><button type='button' data-id='#selectResult.cartid#' class='btn btn-danger btn-flat cart_delete'><i class='fa fa-remove'></i></button></td>
                    <td><img src='#image#' width='30px' height='30px'></td>
                    <td>#selectResult.name#</td>
                    <td>&##36; #numberFormat(selectResult.price, '9.99')#</td>
                    <td class='input-group'>
                        <span class='input-group-btn'>
                            <button type='button' id='minus' class='btn btn-default btn-flat minus' data-id='#selectResult.cartid#'><i class='fa fa-minus'></i></button>
                        </span>
                        <input type='text' class='form-control' value='#selectResult.quantity#' id='qty_#selectResult.cartid#'>
                        <span class='input-group-btn'>
                            <button type='button' id='add' class='btn btn-default btn-flat add' data-id='#selectResult.cartid#'><i class='fa fa-plus'></i></button>
                        </span>
                    </td>
                    <td>&##36; #numberFormat(subtotal, '9.99')#</td>
                </tr>
            ">
        </cfloop>
        <cfset output &= "
            <tr>
                <td colspan='5' align='right'><b>Total</b></td>
                <td><b>&##36; #numberFormat(total, '9.99')#</b></td>
            </tr>
        ">
    <cfcatch type="database">
        <cfset output = cfcatch.message>
    </cfcatch>
    </cftry>
<cfelse>
    <cfif arrayLen(session.cart) GT 0>
        <cfloop array="#session.cart#" index="row">
			<cfscript>
				queryService = new query();
				queryService.setDatasource("fashion");
				queryService.setName("loginUser");
				queryService.addParam(name="id",value="#row.productid#",cfsqltype="cf_sql_varchar");
				result = queryService.execute(sql="SELECT *, products.name AS prodname, category.name AS catname FROM products LEFT JOIN category ON category.id=products.category_id WHERE products.id=:id");
				selectProductResult = result.getResult();
				getProductInfo = result.getPrefix();
			</cfscript>
            <cfset image = (len(trim(selectProductResult.photo)) GT 0) ? 'images/' & selectProductResult.photo : 'images/noimage.jpg'>
            <cfset subtotal = selectProductResult.price * row.quantity>
            <cfset total = total + subtotal>
            <cfset output &= "
                <tr>
                    <td><button type='button' data-id='#row.productid#' class='btn btn-danger btn-flat cart_delete'><i class='fa fa-remove'></i></button></td>
                    <td><img src='#image#' width='30px' height='30px'></td>
                    <td>#selectProductResult.name#</td>
                    <td>&##36; #numberFormat(product.price, '9.99')#</td>
                    <td class='input-group'>
                        <span class='input-group-btn'>
                            <button type='button' id='minus' class='btn btn-default btn-flat minus' data-id='#row.productid#'><i class='fa fa-minus'></i></button>
                        </span>
                        <input type='text' class='form-control' value='#row.quantity#' id='qty_#row.productid#'>
                        <span class='input-group-btn'>
                            <button type='button' id='add' class='btn btn-default btn-flat add' data-id='#row.productid#'><i class='fa fa-plus'></i></button>
                        </span>
                    </td>
                    <td>&##36; #numberFormat(subtotal, '9.99')#</td>
                </tr>
            ">
        </cfloop>
        <cfset output &= "
            <tr>
                <td colspan='5' align='right'><b>Total</b></td>
                <td><b>&##36; #numberFormat(total, '9.99')#</b></td>
            </tr>
        ">
    <cfelse>
        <cfset output &= "
            <tr>
                <td colspan='6' align='center'>Shopping cart empty</td>
            </tr>
        ">
    </cfif>
</cfif>
<cfoutput>#serializeJSON(output)#</cfoutput>