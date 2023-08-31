<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "delete")>
	<cfset id = form.id>
	
	<cfset conn = application.pdo.open()>

	<cftry>
		<cfquery datasource="#dsn#">
			DELETE FROM products WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfset session.success = "Product deleted successfully">
		<cfcatch type="any">
			<cfset session.error = cfcatch.message>
		</cfcatch>
	</cftry>

	<cfset application.pdo.close()>

	<cflocation url="products.cfm">
<cfelse>
	<cfset session.error = "Select product to delete first">
	<cflocation url="products.cfm">
</cfif>
