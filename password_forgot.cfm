<cfinclude template="includes/session.cfm"> 
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
    	<p class="login-box-msg">Enter email associated with account</p>

    	<form action="reset.php" method="POST">
      		<div class="form-group has-feedback">
        		<input type="email" class="form-control" name="email" placeholder="Email" required>
        		<span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      		</div>
      		<div class="row">
    			<div class="col-xs-4">
          			<button type="submit" class="btn btn-primary btn-block btn-flat" name="reset"><i class="fa fa-mail-forward"></i> Send</button>
        		</div>
      		</div>
    	</form>
      <br>
      <a href="login.cfm">I rememberd my password</a><br>
      <a href="index.cfm"><i class="fa fa-home"></i> Home</a>
  	</div>
</div>
	
<cfinclude template="includes/scripts.cfm">
</body>
</html>