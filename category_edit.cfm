<cfinclude template="includes/session.cfm">
<cfparam name="form.edit" default="">
<cfif structKeyExists(form, "edit")>
	<cfset id = form.id>
	<cfset name = form.name>
	<cftry>
		<cfquery name="category" datasource="fashion" RETURNTYPE="array">
			UPDATE category SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
		</cfquery>
		<cfset session.success = "Category updated successfully">
		<cfcatch type="any">
			<cfset session.error = cfcatch.message>
		</cfcatch>
	</cftry>
	
<cfelse>
	<cfset session.error = "Fill up edit category form first">
</cfif>

<cflocation url="category.cfm">
