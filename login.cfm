<cfinclude template="includes/session.cfm"> 

<cfif structKeyExists(session, "user")>
    <cflocation url="cart_view.cfm">
</cfif>

<cfinclude template="includes/header.cfm">

<body class="hold-transition login-page">
    <div class="login-box">
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

        <div class="login-box-body">
            <p class="login-box-msg">Sign in to start your session</p>

            <form action="verify.cfm" method="POST">
                <div class="form-group has-feedback">
                    <input type="email" class="form-control" name="email" placeholder="Email" value="<cfoutput>#session.email ?: ''#</cfoutput>" required>
                    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <input type="password" class="form-control" name="password" placeholder="Password" required>
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                </div>
                <div class="row">
                    <div class="col-xs-4">
                        <button type="submit" class="btn btn-primary btn-block btn-flat" name="login"><i
                                class="fa fa-sign-in"></i> Sign In</button>
                    </div>
                </div>
            </form>
            <br>
            <a href="password_forgot.cfm">I forgot my password</a><br>
            <a href="signup.cfm" class="text-center">Register a new membership</a><br>
            <a href="email_activation.cfm" class="text-center">activate my account</a><br>
            <a href="index.cfm"><i class="fa fa-home"></i> Home</a>
        </div>
    </div>

    <cfinclude template="includes/scripts.cfm">
</body>

</html>