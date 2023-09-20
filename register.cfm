<cfinclude template="includes/session.cfm">

<cfif CGI.REQUEST_METHOD EQ "POST">
    <cfif structKeyExists(form, "signup") and not structKeyExists(form, "activation")>

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


                    <cfscript>
                    userid = insertResultmetaInfo.GENERATED_KEY;
                    base_url = CGI.REMOTE_ADDR;

                    // Define email and subject variables
                    email = "#email#"; // Replace with the actual email
                    subject = "Activation Email"; // Replace with the actual subject

                    message = "
                        <h2>Thank you for Registering.</h2>
                        <p>Your Account:</p>
                        <p>Email: #email#</p>
                        <p>Please click the link below to activate your account.</p>
                        <a href='http://127.0.0.1:8500/africomm/activate.cfm?code=#code#&user=#userid#'>Activate Account</a>
                    ";
                    

                    redirect_success = "signup.cfm";

                    try {
                    // Create a cfhttp object
                    cfhttp = new http();

                    // Set the URL and method
                    cfhttp.setURL("http://127.0.0.1:4000/mail/sendmail");
                    cfhttp.setMethod("POST");

                    // Set the form fields
                    cfhttp.addParam(type="formfield", name="email", value=email);
                    cfhttp.addParam(type="formfield", name="message", value=message);
                    cfhttp.addParam(type="formfield", name="subject", value=subject);

                    // Set a longer timeout value (e.g., 120 seconds)
                    cfhttp.setTimeout(60);

                    // Execute the HTTP request
                    response = cfhttp.send().getPrefix();;

                    // Check if the email was sent successfully
                    if (response.statuscode contains 200) {
                            // Email sent successfully
                            session.success = 'Account created. Check your email to activate.';
                            location(url="#redirect_success#");
                        } else {
                            // Handle email sending failure
                            session.error = 'Account created, but there was an issue sending the activation email.';
                            location(url="#redirect_success#");
                        }
                    } catch (any e) {
                        // Handle any exceptions here
                        session.error = 'Error creating account: ' & e.getMessage();
                        location(url="#redirect_success#");
                    }
                </cfscript>



                    <!-- Session variables for success -->
                    <cfset structDelete(session, "firstname")>
                    <cfset structDelete(session, "lastname")>
                    <cfset structDelete(session, "email")>


                <cfcatch type="database">
                    <cfset session.error = cfcatch.message>
                    <cflocation url="signup.cfm">
                </cfcatch>
                </cftry>

            
            </cfif>
        </cfif>
    </cfif>


</cfif>
