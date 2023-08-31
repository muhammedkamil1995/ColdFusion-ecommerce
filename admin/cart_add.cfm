<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "add")>
    <cfset id = form.id>
    <cfset product = form.product>
    <cfset quantity = form.quantity>

    <cfset conn = pdo.open()>

    <cfquery name="checkProductQuery" datasource="#pdo.getDSN()#">
        SELECT *, COUNT(*) AS numrows FROM cart WHERE product_id=:id
    </cfquery>
    
    <cfset row = checkProductQuery.getResult()>

    <cfif row.numrows GT 0>
        <cfset session.error = 'Product exist in cart'>
    <cfelse>
        <cftry>
            <cfquery name="insertCartQuery" datasource="#pdo.getDSN()#">
                INSERT INTO cart (user_id, product_id, quantity) VALUES (:user, :product, :quantity)
            </cfquery>
            <cfset session.success = 'Product added to cart'>
            <cfcatch type="any">
                <cfset session.error = cfcatch.message>
            </cfcatch>
        </cftry>
    </cfif>

    <cfset pdo.close()>

    <cflocation url="cart.cfm?user=#id#">
</cfif>
