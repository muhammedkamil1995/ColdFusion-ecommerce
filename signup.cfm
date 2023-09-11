<cfinclude template="includes/session.cfm"> 

<cfif structKeyExists(session, "user")>
    <cflocation url="cart_view.cfm">
</cfif>

<cfif structKeyExists(session, "captcha")>
    <cfset now = Now()>
    <cfset captchaTime = session.captcha>
    <cfif now GTE captchaTime>
      <cfset structDelete(session, "captcha")>
    </cfif>
</cfif>


<!--<cfset message = "
                    <h2>Thank you for Registering.</h2>
                    <p>Your Account:</p>
                    <p>Please click the link below to activate your account.</p>
                ">

<cfscript>
    subject = 'Welcome to Afric Comm'
    mailFrom = 'kamzyocoded@gmail.com'
    mailerService = new mail();
    mailerService.setTo('kamzycoded@rocketmail.com');
    mailerService.setUsername(mailFrom);
    mailerService.setServer('smtp.gmail.com');
    mailerService.setPassword('vqrpuldbikmeyrfu');
    mailerService.setFrom(mailFrom);
    mailerService.setSubject(subject);
    mailerService.setType("html");
    mailerService.send(body=message);
</cfscript> 

<cfmail to="kamzycoded@rocketmail.com"
	from="kamzyocoded@gmail.com"
	subject="Welcome to Bedrock"
	type="text" 
    server="smtp.gmail.com" 
    username="kamzycoded@rocketmail.com"
    password="vqrpuldbikmeyrfu">
	Dear Kamil

	We, here at Bedrock, would like to thank you for joining.

	Attached is a PDF document outlining our terms and conditions.

	Best wishes
	Barney
</cfmail>
-->

<!--<cfmail to="tulbadex@rocketmail.com"
	from="kamzyocoded@gmail.com"
	subject="Welcome to Bedrock"
	type="text" 
>
	Dear Kamil

	We, here at Bedrock, would like to thank you for joining.

	Attached is a PDF document outlining our terms and conditions.

	Best wishes
	Barney
</cfmail>-->

<cfmail 
    to="tulbadex@rocketmail.com" 
    from="kamzyocoded@gmail.com" 
    subject="Welcome to Africomm" 
    type="html" 
    server="smtp.gmail.com" 
    port="587" 
    username="kamzyocoded@gmail.com" 
    password="vqrpuldbikmeyrfu" 
    useTLS="true" 
>
    Dear Kamil

	We, here at Bedrock, would like to thank you for joining.

	Attached is a PDF document outlining our terms and conditions.

	Best wishes
	Barney
</cfmail>

<cfinclude template="includes/header.cfm">

<body class="hold-transition register-page">
    <div class="register-box">
  <cfoutput>
      <cfif structKeyExists(session, "error")>
          <div class="callout callout-danger text-center">
            #session.error#
          </div>
          <cfset structDelete(session, "error")>
      </cfif>

      <cfif structKeyExists(session, "success")>
          <div class="callout callout-success text-center">
            #session.success#
          </div>
          <cfset structDelete(session, "success")>
      </cfif>
    </cfoutput>

        <div class="register-box-body">
            <p class="login-box-msg">Register a new membership</p>

            <form action="register.cfm" method="POST">

                <div class="form-group has-feedback">
                    <input type="text" class="form-control" name="firstname" placeholder="Firstname"
                        value="<cfoutput>#session.firstname ?: ''#</cfoutput>" required>
                    <span class="glyphicon glyphicon-user form-control-feedback"></span>
                </div>

                <div class="form-group has-feedback">
                    <input type="text" class="form-control" name="lastname" placeholder="Lastname"
                        value="<cfoutput>#session.lastname ?: ''#</cfoutput>" required>
                    <span class="glyphicon glyphicon-user form-control-feedback"></span>
                </div>

                <div class="form-group has-feedback">
                    <input type="email" class="form-control" name="email" placeholder="Email"
                        value="<cfoutput>#session.email ?: ''#</cfoutput>" required>
                    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                </div>

                <div class="form-group has-feedback">
                    <input type="password" class="form-control" name="password" placeholder="Password" required>
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                </div>

                <ul>
                    <li>May contain letter and numbers</li>
                    <li>Must contain at least 1 number and 1 letter</li>
                    <li>May contain any of these characters: !@#$%</li>
                    <li>Must be 8-24 characters</li>
                </ul>

                <div class="form-group has-feedback">
                    <input type="password" class="form-control" name="repassword" placeholder="Retype password"
                        required>
                    <span class="glyphicon glyphicon-log-in form-control-feedback"></span>
                </div>

                <cfif not structKeyExists(session, "captcha")>
                    <div class="form-group" style="width:100%;">
                        <div class="g-recaptcha" data-sitekey="6LdbMx4nAAAAABF4HQSlqIwMxyUdDq21Lu66HrHl"></div>
                    </div>
                    <cfset structDelete(session, "captcha")>
                </cfif>
                <hr>

                <div class="row">
                    <div class="col-xs-4">
                        <button type="submit" class="btn btn-primary btn-block btn-flat" name="signup"><i
                                class="fa fa-pencil"></i> Sign Up</button>
                    </div>
                </div>
            </form>
            <br>
            <a href="login.cfm">I already have a membership</a><br>
            <a href="index.cfm"><i class="fa fa-home"></i> Home</a>
        </div>
    </div>

    <cfinclude template="includes/scripts.cfm">
</body>

</html>