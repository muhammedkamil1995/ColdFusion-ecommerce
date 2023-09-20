<cfscript>
	include 'includes/session.cfm';

	if (CGI.REQUEST_METHOD EQ "POST") {
		if (structKeyExists(form, "reset")) {
			email = form.email;

			if (len(email) EQ 0) {
				session.error = 'Email is required';
				location(url="password_forgot.cfm");
			}

			if (not isValid("email", email)) {
				session.error = 'Invalid email format';
				location(url="password_forgot.cfm");
			}

			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("selectEmail");
			queryService.addParam(name="email", value="#email#", cfsqltype="cf_sql_varchar");
			result = queryService.execute(sql="SELECT *, COUNT(*) AS numrows FROM users WHERE email=:email");
			getEmail = result.getResult();
			metaInfo = result.getPrefix();

			if (getEmail.numrows GT 0) {
				inputString = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
				shuffledString = "";
				for (i = 0; i < len(inputString); i++) {
					randomIndex = randRange(1, len(inputString));
					shuffledString &= mid(inputString, randomIndex, 1);
					inputString = removeChars(inputString, randomIndex, 1);
				}
				code = left(shuffledString, 15);

				try {
					queryService = new query();
					queryService.setDatasource("fashion");
					queryService.setName("updateUserResetCode");
					queryService.addParam(name="code", value="#code#", cfsqltype="cf_sql_varchar");
					queryService.addParam(name="id", value="#getEmail.id#", cfsqltype="CF_SQL_INTEGER");
					result = queryService.execute(sql="UPDATE users SET reset_code=:code WHERE id=:id");
					updateUserResetCode = result.getResult();
					updateUserResetCodeMetaInfo = result.getPrefix();

					email = "#email#"; // Replace with the actual email
					subject = "Password Reset Email"; // Replace with the actual subject

					// Create the email message
					message = "
						<h2>Password Reset</h2>
						<p>Your Account:</p>
						<p>Email: #email#</p>
						<p>Please click the link below to reset your password:</p>
						<a href='http://127.0.0.1:8500/africomm/password_reset.cfm?code=#code#&user=#getEmail.id#'>Reset Password</a>
					";

					// Define the URL to redirect to after sending the email
					redirect_success = "password_forgot.cfm";

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
							session.success = 'Password reset link sent';
							location(url="#redirect_success#");
						} else {
							// Handle email sending failure
							session.error = 'Error sending reset email';
							location(url="#redirect_success#");
						}
					} catch (any e) {
						// Handle any exceptions here
						session.error = 'Error sending reset email: ' & e.getMessage();
						location(url="password_forgot.cfm");
					}
				} catch (any e) {
					// Handle any exceptions here
					session.error = 'Error: ' & e.getMessage();
					location(url="password_forgot.cfm");
				}
			} else {
				// Handle email not found
				session.error = 'Email not found';
				location(url="password_forgot.cfm");
			}
		}
	}
</cfscript>
