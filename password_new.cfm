<cfinclude template="includes/session.cfm"> 

	<cfif NOT structKeyExists(url, "code") OR NOT structKeyExists(url, "user")>
    	<cflocation url="index.cfm">
    	<cfexit>
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
            SELECT *, COUNT(*) AS numrows FROM users WHERE reset_code = url.code AND id = url.user
        </cfquery>

        <cfif checkResetCode.numrows gt 0>
            <cfset hashedPassword = hash(password, 'SHA-512', "UTF-8")>
            <cftry>
                <cfquery name="updatePassword" datasource="fashion">
                    UPDATE users SET password = hashedPassword WHERE id = url.user
                </cfquery>
                <cfset session.success = 'Password successfully reset'>
                <cflocation url="login.cfm">
            <cfcatch type="any">
                <cfset session.error = cfcatch.message>
                <cflocation url="#path#">
            </cfcatch>
            </cftry>
        <cfelse>
            <cfset session.error = 'Code did not match with user'>
            <cflocation url="#path#">
        </cfif>
    </cfelse>
<cfelse>
    <cfset session.error = 'Input new password first'>
    <cflocation url="#path#">
</cfif>
	