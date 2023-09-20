<cfscript>
    include "includes/session.cfm";

    if (CGI.REQUEST_METHOD EQ "POST") {
        if (structKeyExists(form, "activation") and not structKeyExists(form, "signup")) {
            email = trim(form.email);
            session.email = email;

            if (len(email) EQ 0) {
                session.error = 'Email is required';
                location(url="email_activation.cfm");
            }

            if (!isValid("email", email)) {
                session.error = 'Invalid email format';
                location(url="email_activation.cfm");
            }

            queryService = new query();
            queryService.setDatasource("fashion");
            queryService.setName("sendResetPasswordToUser");
            queryService.addParam(name="email", value=email, cfsqltype="cf_sql_varchar");
            result = queryService.execute(sql="SELECT id, COUNT(*) AS numrows FROM users WHERE email=:email");
            sendResetPasswordToUser = result.getResult();
            getUserInfo = result.getPrefix();

            if (sendResetPasswordToUser.numrows GT 0) {
                inputString = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
                shuffledString = '';

                // Shuffle the characters
                for (i = 1; i <= len(inputString); i++) {
                    randomIndex = randRange(1, len(inputString));
                    shuffledString &= mid(inputString, randomIndex, 1);
                    inputString = removeChars(inputString, randomIndex, 1);
                }

                // Get the first 12 characters of the shuffled string
                code = left(shuffledString, 12);

                queryService = new query();
                queryService.setDatasource("fashion");
                queryService.setName("ResetPasswordUser");
                queryService.addParam(name="email", value=email, cfsqltype="cf_sql_varchar");
                queryService.addParam(name="code", value=code, cfsqltype="cf_sql_varchar");
                result = queryService.execute(sql="UPDATE users SET activate_code = :code WHERE email = :email");
                ResetPasswordUser = result.getResult();
                ResetPasswordResultmetaInfo = result.getPrefix();

                userid = sendResetPasswordToUser.id;
                base_url = CGI.REMOTE_ADDR;

                // Define email and subject variables
                email = "#email#"; // Replace with the actual email
                subject = "Activate Your Account on Afric Comm"; // Replace with the actual subject

                message = "
                    <h2>Thank you for Registering.</h2>
                    <p>Your Account:</p>
                    <p>Email: #email#</p>
                    <p>Please click the link below to activate your account:</p>
                    <a href='http://127.0.0.1:8500/africomm/activate.cfm?code=#code#&user=#userid#'>Activate Account</a>
                ";

                redirect_success = "login.cfm";

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
                        session.success = 'Check your email to activate.';
                        structDelete(session, "email");
                        location(url=redirect_success);
                    } else {
                        // Handle email sending failure
                        session.error = 'Error updating activation code';
                        location(url=redirect_success);
                    }
                } catch (any e) {
                    // Handle any exceptions here
                    session.error = 'Email is either wrong or invalid: ' & e.getMessage();
                    location(url=redirect_success);
                }
            }
        }
    }
</cfscript>
