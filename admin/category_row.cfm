<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "id")>
    <cfset id = form.id>
    
    <cfset conn = pdo.open()>

    <cfquery name="getCategory" datasource="#dsn#">
        SELECT * FROM category WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfset pdo.close()>
    
    <cfcontent type="application/json">
    <cfoutput>#serializeJSON(getCategory)#</cfoutput>
</cfif>
