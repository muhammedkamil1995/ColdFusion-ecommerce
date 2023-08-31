<cfinclude template="includes/session.cfm">
<cfinclude template="includes/slugify.cfm">

<cfif structKeyExists(form, "edit")>
	<cfset id = form.id>
	<cfset name = form.name>
	<cfset slug = slugify(name)>
	<cfset category = form.category>
	<cfset price = form.price>
	<cfset description = form.description>
	
	<cfset conn = application.pdo.open()>

	<cftry>
		<cfquery datasource="#dsn#">
			UPDATE products 
			SET name = <cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">,
				slug = <cfqueryparam value="#slug#" cfsqltype="cf_sql_varchar">,
				category_id = <cfqueryparam value="#category#" cfsqltype="cf_sql_integer">,
				price = <cfqueryparam value="#price#" cfsqltype="cf_sql_decimal">,
				description = <cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar">
			WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfset session.success = "Product updated successfully">
		<cfcatch type="any">
			<cfset session.error = cfcatch.message>
		</cfcatch>
	</cftry>

	<cfset application.pdo.close()>

	<cflocation url="products.cfm">
<cfelse>
	<cfset session.error = "Fill up edit product form first">
	<cflocation url="products.cfm">
</cfif>
