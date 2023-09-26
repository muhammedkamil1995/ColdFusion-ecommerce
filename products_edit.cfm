<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "edit")>
    <cfset id = form.id>
    <cfset name = form.name>
    <cfset slug = slugify(name)>
    <cfset category = form.category>
    <cfset price = form.price>
    <cfset description = form.description>

    <cftry>
        <cfquery name="updateProduct" datasource="fashion">
            UPDATE products
            SET 
            name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
            slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#slug#">,
            category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#category#">,
            price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#price#">,
            description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>

        <cfset session.success = 'Product updated successfully'>
    <cfcatch type="any">
        <cfset session.error = cfcatch.message>
    </cfcatch>
    </cftry>
</cfif>

<cflocation url="products.cfm">
