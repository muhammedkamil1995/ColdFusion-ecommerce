<cfinclude template="includes/session.cfm">
<cfparam name="form.id" default="">

<cfif isNumeric(form.id) and form.id neq "">
    <cfset id = form.id>
    
    <cfquery name="productRow" datasource="fashion" RETURNTYPE="array">
        SELECT products.*, products.id AS prodid, products.name AS prodname, category.name AS catname
        FROM products
        LEFT JOIN category ON category.id = products.category_id
        WHERE products.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>

    <cfcontent type="application/json">
    <cfoutput>#SerializeJSON(productRow)#</cfoutput>
</cfif>
