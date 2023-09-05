<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "signup")>

    <cfparam name="form.firstname" default="">
    <cfparam name="form.lastname" default="">
    <cfparam name="form.email" default="">
    <cfparam name="form.password" default="">
    <cfparam name="form.repassword" default="">

    <!-- Initialize variables -->
    <cfset protocol = "http://">
    <cfif cgi.SERVER_PORT_SECURE>
        <cfset protocol = "https://">
    </cfif>
    <cfset host = cgi.HTTP_HOST>
    <cfset base_url = protocol & host>

    <!-- Get form inputs -->
    <cfset firstname = trim(form.firstname)>
    <cfset lastname = trim(form.lastname)>
    <cfset email = trim(form.email)>
    <cfset password = trim(form.password)>
    <cfset repassword = trim(form.repassword)>

    <!-- Store form inputs in session -->
    <cfset session.firstname = firstname>
    <cfset session.lastname = lastname>
    <cfset session.email = email>

    <!-- Validate first name -->
    <cfif len(firstname) EQ 0>
        <cfset session.error = 'First Name is required'>
        <cflocation url="signup.cfm">
    </cfif>
    
    <cfif not reFind("^[a-zA-Z']*$", firstname)>
        <cfset session.error = 'First Name must contain only letters'>
        <cflocation url="signup.cfm">
    </cfif>

    <cfif len(firstname) GT 20>
        <cfset session.error = 'First Name can not be more than 20 characters'>
        <cflocation url="signup.cfm">
    </cfif>

    <cfif len(firstname) LT 3>
        <cfset session.error = 'First Name can not be less than 3 characters'>
        <cflocation url="signup.cfm">
    </cfif>

    <!-- Validate last name -->
    <cfif len(lastname) EQ 0>
        <cfset session.error = 'Last Name is required'>
        <cflocation url="signup.cfm">
    </cfif>

    <cfif not reFind("^[a-zA-Z']*$", lastname)>
        <cfset session.error = 'Last Name must contain only letters'>
        <cflocation url="signup.cfm">
    </cfif>

    <cfif len(lastname) GT 20>
        <cfset session.error = 'Last Name can not be more than 20 characters'>
        <cflocation url="signup.cfm">
    </cfif>

    <cfif len(lastname) LT 3>
        <cfset session.error = 'Last Name can not be less than 3 characters'>
        <cflocation url="signup.cfm">
    </cfif>

    <!-- Validate email -->
    <cfif len(email) EQ 0>
        <cfset session.error = 'Email is required'>
        <cflocation url="signup.cfm">
    </cfif>

    <cfif not isValid("email", email)>
        <cfset session.error = 'Invalid email format'>
        <cflocation url="signup.cfm">
    </cfif>

    <!-- Validate password  ("^(?=.*\d)(?=.*[A-Za-z])[0-9A-Za-z!@#$%]{8,24}$", password)-->
    <cfif NOT 
    ( len(password) GTE 6
    AND refind('[A-Z]',password)
    AND refind('[a-z]',password)
    AND refind('[0-9]',password)
    AND refind('[!@##$&*]',password)
     )>
        <cfset session.error = 'The password does not meet the requirements!'>
        <cflocation url="signup.cfm">
    </cfif>

    <!-- Verify reCaptcha -->
    <cfif not structKeyExists(session, "captcha")>
        <cfset secret = '6LdbMx4nAAAAAOi4zVP4MVz1CdZSj2WhDQD3HXiA'>
        <cfhttp url="https://www.google.com/recaptcha/api/siteverify?secret=#secret#&response=#FORM['g-recaptcha-response']#" result="Response" />
        <cfset Return = deserializeJSON(Response.FileContent) />

        <cfif not Return.success IS 'true' AND not Return.score GT 0.5>
            <cfset session.error = 'Please answer reCAPTCHA correctly'>
            <cflocation url="signup.cfm">
        <cfelse>
            <!--<cfset session.captcha = now() + (10 * 60)>-->
            <cfset session.captcha = dateAdd("n", 10, now())>
        </cfif>
    </cfif>

    <!-- Verify password match -->
    <cfif password NEQ repassword>
        <cfset session.error = 'Passwords did not match'>
        <cflocation url="signup.cfm">
    <cfelse>
        

        <!-- Check if email is already taken -->
		<cfscript>
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setDatasource("fashion");
			queryService.setName("selectEmail");
			queryService.addParam(name="email",value="#email#",cfsqltype="cf_sql_varchar");
			result = queryService.execute(sql="SELECT COUNT(*) AS numrows FROM users WHERE email=:email");
			getEmail = result.getResult();
			metaInfo = result.getPrefix();
		</cfscript>

        <cfif getEmail.numrows GT 0>
            <cfset session.error = 'Email already taken'>
            <cflocation url="signup.cfm">
        <cfelse>
            <!-- Create activation code -->
            <cfset now = LSDateFormat(now(), 'yyyy-mm-dd')>
			<cfscript> 
				options = StructNew() 
				options.rounds = 4 
				options.version = "$2a" 
			</cfscript>
            <cfset hashPassword = GenerateBCryptHash(password, options)>

            <cfset inputString = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'>
            <cfset shuffledString = "">

            <!-- Shuffle the characters -->
            <cfloop from="1" to="#len(inputString)#" index="i">
                <cfset randomIndex = randRange(1, len(inputString))>
                <cfset shuffledString &= mid(inputString, randomIndex, 1)>
                <cfset inputString = removeChars(inputString, randomIndex, 1)>
            </cfloop>

            <!-- Get the first 12 characters of the shuffled string -->
            <cfset code = left(shuffledString, 12)>

            <!-- Insert user data into the database -->
            <cftry>
				<cfscript>
					queryService = new query();
					queryService.setDatasource("fashion");
					queryService.setName("insertUser");
					queryService.addParam(name="email",value="#email#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="password",value="#hashPassword#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="firstname",value="#firstname#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="lastname",value="#lastname#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="code",value="#code#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="now",value="#now#",cfsqltype="cf_sql_date");
					result = queryService.execute(sql="INSERT INTO users(email, password, firstname, lastname, activate_code, created_on) 
                    VALUES(:email, :password, :firstname, :lastname, :code, :now)");
                    insertUser = result.getResult();
                    insertResultmetaInfo = result.getPrefix();
				</cfscript>

                <cfset userid = insertResultmetaInfo.GENERATED_KEY>
                <!-- GENERATEDKEY
                GENERATED_KEY-->

                <!-- Email message -->
                <cfset message = "
                    <h2>Thank you for Registering.</h2>
                    <p>Your Account:</p>
                    <p>Email: #email#</p>
                    <p>Please click the link below to activate your account.</p>
                    <a href='#base_url#/ecommerce/activate.cfm?code=#code#&user=#userid#'>Activate Account</a>
                ">

                <cfscript>
                    subject = 'Welcome to Afric Comm'
                    mailFrom = 'kamzyocoded@gmail.com'
                    mailerService = new mail();
                    mailerService.setServer('smtp.gmail.com');
                    mailerService.setUsername(mailFrom);
                    mailerService.setPassword('vqrpuldbikmeyrfu');
                    mailerService.setPort(465);
                    mailerService.setTo(email);
                    mailerService.setFrom(mailFrom);
                    mailerService.setSubject(subject);
                    mailerService.setType("html");
                    mailerService.send(body=message);
                </cfscript>

                <!-- Session variables for success -->
                <cfset structDelete(session, "firstname")>
                <cfset structDelete(session, "lastname")>
                <cfset structDelete(session, "email")>

                <!-- Success message -->
                <cfset session.success = 'Account created. Check your email to activate.'>

                <!-- Redirect URL on success -->
                <cflocation url="signup.cfm">

            <cfcatch type="database">
                <cfset session.error = cfcatch.message>
                <cflocation url="signup.cfm">
            </cfcatch>
            </cftry>

           
        </cfif>
    </cfif>
</cfif>

<cfif structKeyExists(form, "activation")>
    <cfset email = trim(form.email)>
    <cfset session.email = email>

    <cfif len(email) EQ 0>
        <cfset session.error = 'Email is required'>
        <cflocation url="email_activation.cfm">
    </cfif>

    <cfif not isValid("email", email)>
        <cfset session.error = 'Invalid email format'>
        <cflocation url="email_activation.cfm">
    </cfif>

    <cfset stmt = conn.prepare("SELECT id, COUNT(*) AS numrows FROM users WHERE email=:email")>
    <cfset stmt.execute({email: email})>
    <cfset row = stmt.fetch()>

    <cfif row.numrows GT 0>
        <cfset set = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'>
        <cfset code = left(randRange(1, len(set)), 12)>

        <cftry>
            <cfset stmt = conn.prepare(
                "UPDATE users SET activate_code = :code WHERE email = :email"
            )>
            <cfset stmt.execute({email: email, code: code})>

            <cfset userid = row.id>

            <cfset message = "
                <h2>Activate Your Account.</h2>
                <p>Your Account:</p>
                <p>Email: #email#</p>
                <p>Please click the link below to activate your account.</p>
                <a href='#base_url#/ecommerce/activate.cfm?code=#code#&user=#userid#'>Activate Account</a>
            ">

            <cfset subject = 'Activate Your Account on Afric Comm'>

            <cfset sessionVariables = ["email"]>

            <cfset success = 'Check your email to activate.'>

            <cfset error = 'Message could not be sent. Mailer Error: '>

            <cfset redirect_success = 'email_activation.cfm'>

            <cfset mail_sender(email, subject, message, sessionVariables, success, error, redirect_success, redirect_success)>
        <cfcatch>
            <cfset session.error = 'Error updating activation code'>
            <cflocation url="email_activation.cfm">
        </cfcatch>
        </cftry>

        
    <cfelse>
        <cfset session.error = 'Email is either wrong or invalid'>
        <cflocation url="email_activation.cfm">
    </cfif>
</cfif>
