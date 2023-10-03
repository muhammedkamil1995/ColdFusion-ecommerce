<cfinclude template="includes/session.cfm">
<cfif structKeyExists(form, "add")>
    <cfset id = form.id>
    <cfset product = form.product>
    <cfset quantity = form.quantity>

    <!-- Check if the product exists in the cart -->
    <cfquery name="checkCart" datasource="fashion">
        SELECT COUNT(*) AS numrows
        FROM cart
        WHERE product_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#product#">
    </cfquery>

    <cfset row = checkCart>

    <cfif row.numrows GT 0>
        <cfset session.error = 'Product exists in cart'>
    <cfelse>
        <cftry>
            <!-- Insert the product into the cart -->
            <cfquery name="insertCart" datasource="fashion">
                INSERT INTO cart (user_id, product_id, quantity)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#product#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#quantity#">
                )
            </cfquery>
            <cfset session.success = 'Product added to cart'>
            <cfcatch type="any">
                <cfset session.error = cfcatch.message>
            </cfcatch>
        </cftry>
    </cfif>

    <cflocation url="cart.cfm?user=#id#">
</cfif>
