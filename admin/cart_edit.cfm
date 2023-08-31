<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "edit")>
	<cfset userid = form.userid>
	<cfset cartid = form.cartid>
	<cfset quantity = form.quantity>

	<cftry>
		<cfquery name="updateQuantity" datasource="#dsn#">
			UPDATE cart SET quantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#quantity#">
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#cartid#">
		</cfquery>
		
		<cfset session.success = "Quantity updated successfully">
		<cfcatch type="database">
			<cfset session.error = "An error occurred while updating the quantity: #cfcatch.message#">
		</cfcatch>
	</cftry>
	
	<cflocation url="cart.cfm?user=#userid#">
</cfif>
