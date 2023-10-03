<cfinclude template="includes/session.cfm">
<cfinclude template="includes/slugify.cfm">
<cfif structKeyExists(form, "edit") and structKeyExists(form, "id") and structKeyExists(form, "name")>
	<cfset id = form.id>
	<cfset name = form.name>
	<cfset slug = slugify(name)>

	<cfif len(form.name) gt 0 and isDefined("form.id")>
		<cftry>
			<cfquery name="category" datasource="fashion" RETURNTYPE="array">
				UPDATE category SET 
				name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
				cat_slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#slug#">
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
			</cfquery>
			<cfset session.success = "Category updated successfully">
			<cfcatch type="any">
				<cfset session.error = cfcatch>
			</cfcatch>
		</cftry>
	</cfif>
	
	
<cfelse>
	<cfset session.error = "Fill up edit category form first">
</cfif>

<cflocation url="category.cfm">
