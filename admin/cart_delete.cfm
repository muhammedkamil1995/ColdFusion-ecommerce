<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "delete")>
	<cfset userid = form.userid>
	<cfset cartid = form.cartid>

	<cftry>
		<cfquery name="deleteProduct" datasource="#dsn#">
			DELETE FROM cart WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#cartid#">
		</cfquery>
		
		<cfset session.success = "Product deleted from cart">
		<cfcatch type="database">
			<cfset session.error = "An error occurred while deleting the product from cart: #cfcatch.message#">
		</cfcatch>
	</cftry>
	
	<cflocation url="cart.cfm?user=#userid#">
</cfif>
