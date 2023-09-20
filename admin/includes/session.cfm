<CFAPPLICATION NAME="Afric Comm" SESSIONMANAGEMENT="Yes">
<cfset session.admin = PreserveSingleQuotes(session.admin)>

<cfif structKeyExists(session, "admin")>
    <cflocation url="admin/home.cfm">
</cfif>

<cfif structKeyExists(session, "user")>

    <cftry>
        <cfscript>
            adminId = session.admin;

             sql = "
        SELECT *
        FROM users
        WHERE id = :adminId
        ";

        admin = {};

            try {
        admin = queryExecute(sql, {}, {datasource: "fashion"});

        if (admin.recordCount > 0) {
            admin = admin[1];
                }
        } 
		</cfscript>
        <cfcatch type="any">
            <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
        </cfcatch>
    </cftry>
    
</cfif>