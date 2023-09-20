


<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "add")>
    <cfset id = form.id>
    <cfset product = form.product>
    <cfset quantity = form.quantity>


    <cfquery name="checkProductQuery" datasource="fashion">
        SELECT *, COUNT(*) AS numrows FROM cart WHERE product_id=:id
    </cfquery>
    
    <cfset row = checkProductQuery.getResult()>

    <cfif row.numrows GT 0>
        <cfset session.error = 'Product exist in cart'>
    <cfelse>
        <cftry>
            <cfquery name="insertCartQuery" datasource="fashion">
                INSERT INTO cart (user_id, product_id, quantity) VALUES (:user, :product, :quantity)
            </cfquery>
            <cfset session.success = 'Product added to cart'>
            <cfcatch type="any">
                <cfset session.error = cfcatch.message>
            </cfcatch>
        </cftry>
    </cfif>


    <cflocation url="cart.cfm?user=#id#">
</cfif>
