<cfinclude template="includes/session.cfm">
<cfscript>
	output = ''
	if ( CGI.REQUEST_METHOD EQ "GET" ) {
		if ( not structKeyExists(url, 'code') OR not not structKeyExists(url, 'user')) {
			output &= '
				<div class="alert alert-danger">
					<h4><i class="icon fa fa-warning"></i> Error!</h4>
					Code to activate account not found.
				</div>
				<h4>You may <a href="signup.cfm">Signup</a> or back to <a href="index.cfm">Homepage</a>.</h4>
			'
		} else {
			queryService = new query();
			queryService.setDatasource("fashion");
			queryService.setName("activateAccountResult");
			queryService.addParam(name="code",value="#url.code#",cfsqltype="CF_SQL_VARCHAR");
			queryService.addParam(name="id",value="#url.user#",cfsqltype="CF_SQL_INTEGER");
			result = queryService.execute(sql="SELECT *, COUNT(*) AS numrows FROM users WHERE activate_code=:code AND id=:id");
			activateAccountResult = result.getResult();
			activateAccountResultInfo = result.getPrefix();

			if ( activateAccountResultInfo.recordcount eq 1 ) {
				if ( activateAccountResult.status ) {
					output &= '
						<div class="alert alert-danger">
							<h4><i class="icon fa fa-warning"></i> Error!</h4>
							Account already activated.
						</div>
						<h4>You may <a href="login.cfm">Login</a> or back to <a href="index.cfm">Homepage</a>.</h4>
					'
				} else {
					try{
						queryService.setName("activateAccountStatusResult");
						status = 1
						queryService.addParam(name="status",value="#status#",cfsqltype="CF_SQL_INTEGER");
						queryService.addParam(name="id",value="#url.user#",cfsqltype="CF_SQL_INTEGER");
						result = queryService.execute(sql="UPDATE users SET status=:status WHERE id=:id");
						activateAccountStatusResult = result.getResult();
						activateAccountStatusResultnfo = result.getPrefix();

						if ( activateAccountStatusResultnfo.recordcount eq 1 ) {
							output &= '
								<div class="alert alert-success">
									<h4><i class="icon fa fa-check"></i> Success!</h4>
									Account activated - Email: <b>#row['email']#</b>.
								</div>
								<h4>You may <a href="login.cfm">Login</a> or back to <a href="index.cfm">Homepage</a>.</h4>
							';
						}
					} catch(type database) {
						output &= '
							<div class="alert alert-danger">
								<h4><i class="icon fa fa-warning"></i> Error!</h4>
								#cfcatch.message#
							</div>
							<h4>You may <a href="signup.cfm">Signup</a> or back to <a href="index.cfm">Homepage</a>.</h4>
						';
					}
				}
			} else {
				$output &= '
					<div class="alert alert-danger">
						<h4><i class="icon fa fa-warning"></i> Error!</h4>
						Cannot activate account. Wrong code.
					</div>
					<h4>You may <a href="signup.cfm">Signup</a> or back to <a href="index.cfm">Homepage</a>.</h4>
				';
			}
		}
	}
</cfscript>

<cfinclude template="includes/header.cfm">

<body class="hold-transition skin-blue layout-top-nav">
    <div class="wrapper">

        <cfinclude template="includes/navbar.cfm">

        <div class="content-wrapper">
            <div class="container">

                <!-- Main content -->
                <section class="content">
                    <div class="row">
                        <div class="col-sm-9">
							<cfoutput>#output#</cfoutput>
                        </div>
                        <div class="col-sm-3">
                            <cfinclude template="includes/sidebar.cfm">
                        </div>
                    </div>
                </section>

            </div>
        </div>

        <cfinclude template="includes/footer.cfm">
    </div>

    <cfinclude template="includes/scripts.cfm">
</body>

</html>