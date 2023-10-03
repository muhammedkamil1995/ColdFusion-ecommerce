<cfinclude template="includes/session.cfm">
<cfif structKeyExists(form, "id")>
	<cfset id = form.id>
	<cfset row = {}>

	<cftry>
		<cfquery name="products" datasource="fashion" RETURNTYPE="array">
			SELECT cart.id AS cartid, cart.user_id, cart.quantity, products.* 
			FROM cart 
			LEFT JOIN products ON products.id = cart.product_id 
			WHERE cart.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
		</cfquery>

		<cfset row = #products#>
		<cfcatch type="database">
			<cfset row.error = "An error occurred while fetching data: #cfcatch.message#">
		</cfcatch>
	</cftry>

	<cfcontent type="application/json">
	<cfoutput>#serializeJSON(row)#</cfoutput>
</cfif>
