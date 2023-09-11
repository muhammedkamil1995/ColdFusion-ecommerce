<cfinclude template="includes/session.cfm"> 

<cfif NOT structKeyExists(url, "code") OR NOT structKeyExists(url, "user")>
    <cflocation url="index.cfm">
    <cfexit method = "exitTemplate">
</cfif>
<cfinclude template="includes/header.cfm">

<body class="hold-transition login-page">
<div class="login-box">

<cfif structKeyExists(session, "error")>
    <div class="callout callout-danger text-center">
        <<cfoutput>
			<p>#session.error#</p>
		</cfoutput>
    </div>
    <cfset structDelete(session, "error")>
</cfif>


  	<div class="login-box-body">
    	<p class="login-box-msg">Enter new password</p>

    	
          <form action="password_new.cfm?code=#url.code#&user=#url.user#" method="post">
      		<div class="form-group has-feedback">
        		<input type="password" class="form-control" name="password" placeholder="New password" required>
        		<span class="glyphicon glyphicon-lock form-control-feedback"></span>
      		</div>
          <div class="form-group has-feedback">
            <input type="password" class="form-control" name="repassword" placeholder="Re-type password" required>
            <span class="glyphicon glyphicon-log-in form-control-feedback"></span>
          </div>
      		<div class="row">
    			<div class="col-xs-4">
          			<button type="submit" class="btn btn-primary btn-block btn-flat" name="reset"><i class="fa fa-check-square-o"></i> Reset</button>
        		</div>
      		</div>
    	</form>
  	</div>
</div>
	
<cfinclude template="includes/scripts.cfm">
</body>
</html>