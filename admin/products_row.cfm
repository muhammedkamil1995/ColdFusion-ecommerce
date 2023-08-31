<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "id")>
	<cfset id = form.id>

	<cfset conn = application.pdo.open()>

	<cfquery datasource="#dsn#">
		SELECT *, products.id AS prodid, products.name AS prodname, category.name AS catname 
		FROM products 
		LEFT JOIN category ON category.id = products.category_id 
		WHERE products.id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset row = queryGetRow(result)>

	<cfset application.pdo.close()>

	<cfoutput>#serializeJSON(row)#</cfoutput>
</cfif>
