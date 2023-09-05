<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "login")>

    <cfset email = trim(form.email)>
    <cfset password = trim(form.password)>
	<cfset session.email = email>

    <cfif len(trim(email)) eq 0>
        <cfset session.error = "Email is required">
        <cflocation url="login.cfm" addtoken="false">
        <cfexit>
    </cfif>

    <cfif not isValid("email", email)>
        <cfset session.error = "Invalid email format">
        <cflocation url="login.cfm" addtoken="false">
        <cfexit>
    </cfif>

    <cfif len(trim(password)) eq 0>
        <cfset session.error = "Password is required">
        <cflocation url="login.cfm" addtoken="false">
        <cfexit>
    </cfif>

</cfif>

<cfif isDefined("form.email") AND isDefined("form.password")>

    <cfset email = form.email>
    <cfset password = form.password>

    <cftry>
        <!--- Create a prepared statement to fetch user data by email --->
		<cfscript>
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("loginUser");
			queryService.addParam(name="email", value="#email#", cfsqltype="cf_sql_varchar");
			result = queryService.execute(sql="SELECT *, COUNT(*) AS numrows FROM users WHERE email = :email");
			userResult = result.getResult();
			getUserInfo = result.getPrefix();
		</cfscript>

        <!--- Check if any rows were found --->
        <cfif userResult.numrows GT 0>
            <cfif userResult.status>
                <!--- Verify the password --->
                <cfif VerifyBCryptHash(password, userResult.password)>
                    <cfif userResult.type>
                        <cfset session.admin = userResult.id>
                    <cfelse>
                        <cfset session.user = userResult.id>
                    </cfif>
                <cfelse>
                    <cfset session.error = 'Incorrect Password'>
                </cfif>
            <cfelse>
                <cfset session.error = 'Account not activated.'>
            </cfif>
        <cfelse>
            <cfset session.error = 'Email not found'>
        </cfif>

    <cfcatch type="any">
        <cfset session.error = 'There is some problem in connection: #cfcatch.message#'>
    </cfcatch>
    </cftry>

<cfelse>
    <cfset session.error = 'Input login credentials first'>
</cfif>

<cflocation url="login.cfm">




