<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "id")>
	<cfset id = form.id>
	<cfset row = {}>

	<cftry>
		<cfquery name="cartQuery" datasource="#dsn#">
			SELECT cart.id AS cartid, products.* 
			FROM cart 
			LEFT JOIN products ON products.id = cart.product_id 
			WHERE cart.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
		</cfquery>

		<cfset row = cartQuery[1]>
		<cfcatch type="database">
			<cfset row.error = "An error occurred while fetching data: #cfcatch.message#">
		</cfcatch>
	</cftry>

	<cfoutput>#serializeJSON(row)#</cfoutput>
</cfif>
