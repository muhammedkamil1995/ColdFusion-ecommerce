<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "delete")>
	<cfset id = form.id>
	<cfquery name="deleteQuery" datasource="#dsn#">
		DELETE FROM category WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
	</cfquery>
	<cftry>
		<cfquery datasource="#dsn#">
			DELETE FROM category WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
		</cfquery>
		<cfset session.success = "Category deleted successfully">
		<cfcatch type="any">
			<cfset session.error = cfcatch.message>
		</cfcatch>
	</cftry>
	<cfset pdo.close()>
<cfelse>
	<cfset session.error = "Select category to delete first">
</cfif>

<cflocation url="category.cfm">
