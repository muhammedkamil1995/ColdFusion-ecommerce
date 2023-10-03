<cfinclude template="includes/session.cfm">
<cfinclude template="includes/slugify.cfm">

<cfif structKeyExists(form, "add") and isDefined("form.name")>
	<cfset name = form.name>
	<cfset slug = slugify(name)>
	<cfquery name="category" datasource="fashion" RETURNTYPE="array">
		SELECT *, COUNT(*) AS numrows FROM category WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
	</cfquery>
	<cfset row = category[1]>
	<cfif row.numrows gt 0>
		<cfset session.error = "Category already exist">
	<cfelse>
		<cftry>
			<cfquery name="addCategory" datasource="fashion">
				INSERT INTO category (name, cat_slug)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#slug#">
				)
			</cfquery>
			<cfset session.success = "Category added successfully">
			<cfcatch type="any">
				<cfset session.error = cfcatch>
			</cfcatch>
		</cftry>
	</cfif>
	
<cfelse>
	<cfset session.error = "Fill up category form first">
</cfif>

<cflocation url="category.cfm">
