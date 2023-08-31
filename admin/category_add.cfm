<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "add")>
	<cfset name = form.name>
	<cfquery name="categoryQuery" datasource="#dsn#">
		SELECT *, COUNT(*) AS numrows FROM category WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
	</cfquery>
	<cfset row = categoryQuery[1]>
	<cfif row.numrows gt 0>
		<cfset session.error = "Category already exist">
	<cfelse>
		<cftry>
			<cfquery datasource="#dsn#">
				INSERT INTO category (name) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">)
			</cfquery>
			<cfset session.success = "Category added successfully">
			<cfcatch type="any">
				<cfset session.error = cfcatch.message>
			</cfcatch>
		</cftry>
	</cfif>
	<cfset pdo.close()>
<cfelse>
	<cfset session.error = "Fill up category form first">
</cfif>

<cflocation url="category.cfm">
