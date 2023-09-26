<cfinclude template="includes/session.cfm">
<cfif structKeyExists(form, "delete")>
	<cfset userid = form.userid>
	<cfset cartid = form.cartid>

	<cftry>
		<cfquery name="getUserCartDelete" datasource="fashion">
			DELETE FROM cart WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cartid#">
		</cfquery>
		
		<cfset session.success = "Product deleted from cart">
		<cfcatch type="database">
			<cfset session.error = "An error occurred while deleting the product from cart: #cfcatch.message#">
		</cfcatch>
	</cftry>
	
	<cflocation url="cart.cfm?user=#userid#">
</cfif>
