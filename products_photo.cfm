<cfinclude template="includes/session.cfm">

<cfparam name="form.upload" default="">
<cfif form.upload neq "">
    <cfset id = form.id>
    <cfset filename = form.photo>

    <cfquery name="Product" datasource="fashion">
        SELECT * FROM products WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>
    
    <cfset row = Product>

    <cfif len(trim(filename))>
        <cfset ext = listLast(filename, ".")>
        <cfset new_filename = "#row.slug#_#createDateTimeFormat(now(), 'yyyymmddhhmmss')#.#ext#">
        <cffile action="upload" filefield="photo" destination="../images/" nameconflict="MAKEUNIQUE" accept="image/jpg,image/jpeg,image/png,image/gif">
        <cfset filename = cffile.serverFile>
    <cfelse>
        <cfset new_filename = ''>
    </cfif>

    <cftry>
        <cfquery name="updateProduct" datasource="your_datasource">
            UPDATE products
            SET photo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_filename#">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>
        <cfset session.success = 'Product photo updated successfully'>
    <cfcatch type="any">
        <cfset session.error = cfcatch.message>
    </cfcatch>
    </cftry>

    <cflocation url="products.cfm">
</cfif>
