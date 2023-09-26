<cfinclude template="includes/session.cfm">

<cfif structKeyExists(url, "return")>
    <cfset returnPage = url.return>
<cfelse>
    <cfset returnPage = "home.cfm">
</cfif>

<cfif structKeyExists(form, "save")>
    <cfset curr_password = form.curr_password>
    <cfset email = form.email>
    <cfset password = form.password>
    <cfset firstname = form.firstname>
    <cfset lastname = form.lastname>
    <cfset photo = form.photo>

    <cfset admin = session.admin>

    <cfif compare(admin.password, curr_password) EQ 0>
        <cfif isDefined("form.photo")>
            <cffile action="upload" filefield="photo" destination="../images/" nameconflict="makeunique">
            <cfset filename = cffile.serverFile>
        <cfelse>
            <cfset filename = admin.photo>
        </cfif>

        <cfif compare(password, admin.password) EQ 0>
            <cfset password = admin.password>
        <cfelse>
            <cfset password = hash(password, "SHA-256")>
        </cfif>

        <cfquery name="updateQuery" datasource="#application.dsn#">
            UPDATE users
            SET email = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">,
                password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">,
                firstname = <cfqueryparam value="#firstname#" cfsqltype="cf_sql_varchar">,
                lastname = <cfqueryparam value="#lastname#" cfsqltype="cf_sql_varchar">,
                photo = <cfqueryparam value="#filename#" cfsqltype="cf_sql_varchar">
            WHERE id = <cfqueryparam value="#admin.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif updateQuery.recordCount EQ 1>
            <cfset session.success = "Account updated successfully">
        <cfelse>
            <cfset session.error = "An error occurred while updating the account">
        </cfif>
    <cfelse>
        <cfset session.error = "Incorrect password">
    </cfif>

    <cflocation url="#returnPage#" addtoken="false">
<cfelse>
    <cfset session.error = "Fill up required details first">
    <cflocation url="#returnPage#" addtoken="false">
</cfif>
