<cfinclude template="conn.cfc">
<CFAPPLICATION NAME="Afric Comm"
SESSIONMANAGEMENT="Yes">

<cfif structKeyExists(session, "admin")>
    <cflocation url="admin/home.cfm">
</cfif>

<cfif structKeyExists(session, "user")>

    <cftry>
        <cfquery name="getUser" datasource="fashion">
            SELECT * FROM users WHERE id = #session.user#
        </cfquery>
        <cfcatch type="any">
            <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
        </cfcatch>
    </cftry>
    
</cfif>