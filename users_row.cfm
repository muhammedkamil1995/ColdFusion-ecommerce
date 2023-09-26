<cfinclude template="includes/session.cfm"> 
<cfif isNumeric(form.id)>
    <cfset id = form.id>

    <cfquery name="user" datasource="fashion">
        SELECT * FROM users WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>
    <cfset row = {}>

    <cfif user.recordcount gt 0>
        <cfoutput>
            <cfset row.id = user.id>
            <cfset row.firstname = user.firstname>
            <cfset row.lastname = user.lastname>
            <cfset row.email = user.email>
            <cfset row.address = user.address>
            <cfset row.contact_info = user.contact_info>
        </cfoutput>
    </cfif>

    <cfif structKeyExists(row, "id")>
        <cfcontent type="application/json">
        <cfoutput>#serializeJSON(row)#</cfoutput>
        <cfabort>
    </cfif>
</cfif>
