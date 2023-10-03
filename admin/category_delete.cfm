<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "delete")>
	<cfset id = form.id>
	<cftry>
		<cfquery name="deleteCategory" datasource="fashion" RETURNTYPE="array">
			DELETE FROM category WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
		</cfquery>
		<cfset session.success = "Category deleted successfully">
		<cfcatch type="any">
			<cfset session.error = cfcatch.message>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset session.error = "Select category to delete first">
</cfif>

<cflocation url="category.cfm">
