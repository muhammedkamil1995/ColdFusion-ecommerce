<cfinclude template="includes/session.cfm"> 

	<cfif NOT structKeyExists(url, "code") OR NOT structKeyExists(url, "user")>
        <cflocation url="index.cfm">
        <cfexit method="exitTemplate">
    </cfif>

    <cfset path = 'password_reset.cfm?code=' & url.code & '&user=' & url.user>

	<cfif structKeyExists(form, "reset")>
   		<cfset password = form.password>
    	<cfset repassword = form.repassword>

        <cfif password neq repassword>
            <cfset session.error = 'Passwords did not match'>
            <cflocation url="#path#">
        <cfelse>

            <cfquery name="checkResetCode" datasource="fashion">
                SELECT *, COUNT(*) AS numrows
                FROM users
                WHERE reset_code = <cfqueryparam value="#url.code#" cfsqltype="cf_sql_varchar">
                AND id = <cfqueryparam value="#url.user#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>

            <cfif checkResetCode.numrows gt 0>
                <cfscript> 
                    options = StructNew() 
                    options.rounds = 4 
                    options.version = "$2a" 
                </cfscript>
                <cfset hashedPassword = GenerateBCryptHash(password, options)>
                
               <cftry>
                    <cfquery name="updatePassword" datasource="fashion">
                        UPDATE users
                        SET password = <cfqueryparam value="#hashedPassword#" cfsqltype="cf_sql_varchar">
                        WHERE id = <cfqueryparam value="#url.user#" cfsqltype="CF_SQL_INTEGER">
                    </cfquery>
                    <cfset session.success = 'Password successfully reset'>
                    <cflocation url="login.cfm">
                    <cfcatch type="any">
                        <cfset session.error = 'Error occurs while resetting password'>
                        <cflocation url="#path#">
                    </cfcatch>
               </cftry>

            <cfelse>
                <cfset session.error = 'Code did not match with user'>
                <cflocation url="#path#">
            </cfif>
        </cfif>
    <cfelse>
        <cfset session.error = 'Input new password first'>
        <cflocation url="#path#">
    </cfif>
	