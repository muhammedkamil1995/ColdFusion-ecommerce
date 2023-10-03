<cfinclude template="includes/session.cfm"> 
<cfparam name="form.activate" default="">
<cfif structKeyExists(form, "activate") and structKeyExists(form, "id")>
    <cfset id = form.id>


    <cftry>
        <cfquery name="getUseractivate" datasource="fashion">
            UPDATE users
            SET status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>
        <cfset session.success = 'User activated successfully'>
    <cfcatch type="any">
        <cfset session.error = cfcatch.message>
    </cfcatch>
    </cftry>



<cflocation url="users.cfm">
