<cfscript>
	include 'includes/session.cfm';

	if ( CGI.REQUEST_METHOD EQ "POST" ) {
		if ( structKeyExists(form, "reset") ) {
			email = form.email

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
			queryService.addParam(name="email",value="#email#",cfsqltype="cf_sql_varchar");
			result = queryService.execute(sql="SELECT *, COUNT(*) AS numrows FROM users WHERE email=:email");
			getEmail = result.getResult();
			metaInfo = result.getPrefix();

			if ( getEmail.numrows GT 0 ) {
				inputString = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
				shuffledString = ""
				for ( i = 0; i <= len(inputString); i++) {
					randomIndex = randRange(1, len(inputString))
					shuffledString &= mid(inputString, randomIndex, 1)
					inputString = removeChars(inputString, randomIndex, 1)
				}
				code = left(shuffledString, 15)

				
				try {
					$stmt = $conn->prepare("UPDATE users SET reset_code=:code WHERE id=:id");
					$stmt->execute(['code'=>$code, 'id'=>$row['id']]);
					queryService.setName("updateUseResetCode");
					queryService.addParam(name="code",value="#code#",cfsqltype="cf_sql_varchar");
					queryService.addParam(name="id",value="#getEmail.id#",cfsqltype="CF_SQL_INTEGER");
					result = queryService.execute(sql="UPDATE users SET reset_code=:code WHERE id=:id");
					updateUseResetCode = result.getResult();
					updateUseResetCodemetaInfo = result.getPrefix();

					message = "
						<h2>Password Reset</h2>
						<p>Your Account:</p>
						<p>Email: #email#</p>
						<p>Please click the link below to reset your password.</p>
						<a href='http://localhost/ecommerce/password_reset.php?code=#code#&user=#row.id#'>Reset Password</a>
					";

					subject = 'Africomm Site Password Reset'
					mailFrom = 'kamzyocoded@gmail.com'
					mailerService = new mail();
					mailerService.setTo(email);
					mailerService.setUsername(mailFrom);
					mailerService.setServer('smtp.gmail.com');
					mailerService.setPassword('vqrpuldbikmeyrfu');
					mailerService.setFrom(mailFrom);
					mailerService.setSubject(subject);
					mailerService.setType("html");
					mailerService.send(body=message);
					structDelete(session, "email")
					session.success = 'Password reset link sent';
				} catch(type any) {
					session.error = 'Error sending reset email';
				}
				
				
			} else {
				session.error = 'Email not found';
			}
		} else{
			session.error = 'Input email not associated with account';
		}

		location(url='password_forgot.cfm');
	}

</cfscript>