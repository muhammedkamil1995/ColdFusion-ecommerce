<cfinclude template="includes/session.cfm">
<cfinclude template="includes/slugify.cfm">

<cfif structKeyExists(form, "add")>
	<cfset name = form.name>
	<cfset slug = slugify(name)>
	<cfset category = form.category>
	<cfset price = form.price>
	<cfset description = form.description>
	<cfset filename = form.photo>
	
	<cfset conn = application.pdo.open()>

	<cfquery name="stmt" datasource="#dsn#">
		SELECT *, COUNT(*) AS numrows
		FROM products
		WHERE slug = <cfqueryparam value="#slug#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset row = stmt[1]>

	<cfif row.numrows GT 0>
		<cfset session.error = "Product already exist">
	<cfelse>
		<cfif not len(trim(filename))>
			<cfset new_filename = "">
		<cfelse>
			<cfset ext = listLast(filename, ".")>
			<cfset new_filename = slug & "." & ext>
			<cffile action="upload" fileField="photo" destination="../images/" nameConflict="makeUnique">
		</cfif>

		<cftry>
			<cfquery name="stmt" datasource="#dsn#">
				INSERT INTO products (category_id, name, description, slug, price, photo)
				VALUES (
					<cfqueryparam value="#category#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#name#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#slug#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#price#" cfsqltype="cf_sql_decimal">,
					<cfqueryparam value="#new_filename#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cfset session.success = "User added successfully">
			<cfcatch type="any">
				<cfset session.error = cfcatch.message>
			</cfcatch>
		</cftry>
	</cfif>
	
	<cfset application.pdo.close()>
<cfelse>
	<cfset session.error = "Fill up product form first">
</cfif>

<cflocation url="products.cfm">
