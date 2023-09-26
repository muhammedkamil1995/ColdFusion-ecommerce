<cfinclude template="includes/session.cfm"> 
	<cfif structKeyExists(form, "delete")>
		<cfset id = form.id> <!-- Set the 'id' variable based on the value of 'form.id' -->
        
        <cftry>
            <cfquery name="users" datasource="fashion">
                DELETE FROM users WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
            </cfquery>
            <cfset session.success = 'User deleted successfully'>
        <cfcatch type="any">
            <cfset session.error = cfcatch.message>
        </cfcatch>
        </cftry>

        <cflocation url="users.cfm">
    </cfif>
