<cfinclude template="includes/session.cfm">
<cfinclude template="includes/slugify.cfm">

<cfparam name="form.add" default="">
<cfif form.add neq "">
    <cfset name = form.name>
    <cfset category = form.category>
    <cfset price = form.price>
    <cfset description = form.description>
    <cfset filename = form.photo>
    <cfset slug = slugify(name)>

    <cfquery name="Products" datasource="fashion">
        SELECT *, COUNT(*) AS numrows FROM products WHERE slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#slug#">
    </cfquery>
    
    <cfset row = Products>

    <cfif row.numrows GT 0>
        <cfset session.error = 'Product already exists'>
    <cfelse>
        <cfif len(trim(filename))>
            <cfset ext = listLast(filename, ".")>
            <cfset new_filename = "#slug#.#ext#">
            <cffile action="upload" filefield="photo" destination="../images/" nameconflict="MAKEUNIQUE" accept="image/jpg,image/jpeg,image/png,image/gif">
            <cfset filename = cffile.serverFile>
        <cfelse>
            <cfset new_filename = ''>
        </cfif>

        <cftry>
            <cfquery name="insertProduct" datasource="your_datasource">
                INSERT INTO products (category_id, name, description, slug, price, photo)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#category#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#slug#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#price#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_filename#">
                )
            </cfquery>
            <cfset session.success = 'Product added successfully'>
        <cfcatch type="any">
            <cfset session.error = cfcatch.message>
        </cfcatch>
        </cftry>
    </cfif>

    <cflocation url="products.cfm">
</cfif>
