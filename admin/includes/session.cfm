<CFAPPLICATION NAME="Afric Comm" SESSIONMANAGEMENT="Yes">

<cfif not structKeyExists(session, "admin")>
    <cflocation url="../index.cfm">
</cfif>

<cfif structKeyExists(session, "admin")>

    <cftry>

        <cfscript>
            queryService = new query();
            queryService.setDatasource("fashion");
            queryService.setName("getAdminInfo");
            queryService.addParam(name="user",value="#session.admin#",cfsqltype="cf_sql_varchar");
            result = queryService.execute(sql="SELECT * FROM users WHERE id = :user");
            getAdminresult = result.getResult();
            getAdminInfo = result.getPrefix();
		</cfscript>
        <cfcatch type="any">
            <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
        </cfcatch>
    </cftry>
    
</cfif>