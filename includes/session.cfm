<CFAPPLICATION NAME="Afric Comm" SESSIONMANAGEMENT="Yes">

<cfif structKeyExists(session, "admin")>
    <cflocation url="admin/home.cfm">
</cfif>

<cfif structKeyExists(session, "user")>

    <cftry>
        <cfscript>
            queryService = new query();
            queryService.setDatasource("fashion");
            queryService.setName("getUserResult");
            queryService.addParam(name="user",value="#session.user#",cfsqltype="cf_sql_varchar");
            result = queryService.execute(sql="SELECT * FROM users WHERE id = :user");
            getUserResult = result.getResult();
            getUserInfo = result.getPrefix();
		</cfscript>
        <cfcatch type="any">
            <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
        </cfcatch>
    </cftry>
    
</cfif>