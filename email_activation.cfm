<cfinclude template="includes/session.cfm"> 

<cfif structKeyExists(session, "user")>
    <cflocation url="cart_view.cfm">
</cfif>

<cfinclude template="includes/header.cfm">

<body class="hold-transition login-page">
    <div class="login-box">

    <cfif structKeyExists(session, "error")>
        <div class="callout callout-danger text-center">
        <p>#session.error#</p>
        </div>
        <cfset structDelete(session, "error")>
    </cfif>

    <cfif structKeyExists(session, "success")>
        <div class="callout callout-success text-center">
        <p>#session.success#</p>
        </div>
        <cfset structDelete(session, "success")>
    </cfif>

        <div class="login-box-body">
            <p class="login-box-msg">Activat Account</p>

            <form action="register.cfm" method="POST">
                <div class="form-group has-feedback">
                    <input type="email" class="form-control" name="email" placeholder="Email" required>
                    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                </div>

                <div class="row">
                    <div class="col-xs-6">
                        <button type="submit" class="btn btn-primary btn-block btn-flat" name="activation"><i
                                class="fa fa-sign-in"></i> Activat Account</button>
                    </div>
                </div>
            </form>
            <br>
            <a href="password_forgot.cfm">I forgot my password</a><br>
            <a href="signup.cfm" class="text-center">Register a new membership</a><br>
            <a href="index.cfm"><i class="fa fa-home"></i> Home</a>
        </div>
    </div>

    <cfinclude template="includes/scripts.cfm">
</body>

</html>