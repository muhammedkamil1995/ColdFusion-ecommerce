<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "id")>
    <cfset id = form.id>

    <cfquery name="category" datasource="fashion">
        SELECT * FROM category WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfcontent type="application/json">
    <cfoutput>#serializeJSON(getCategory)#</cfoutput>
</cfif>
