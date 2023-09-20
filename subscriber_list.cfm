<cfscript>
    2

    if (CGI.REQUEST_METHOD EQ "POST") {
        // Decode JSON data from the request
        requestData = deserializeJSON(toString(getHttpRequestData().content));
        response_data = structNew();

        email = trim(requestData.email);
        if (len(email) EQ 0) {
            response_data.status = false;
            response_data.message = 'Email is required';
            WriteOutput(serializeJSON(#response_data#));
            abort;
        }

        if (!isValid("email", email)) {
            response_data.status = false;
            response_data.message = 'Invalid email format';
            WriteOutput(serializeJSON(#response_data#));
            abort;
        }


        // Check if the email is already subscribed (status = true)
        queryService = new query();
        queryService.setDatasource("fashion"); // Set your actual datasource name
        queryService.setName("checkSubscriber");
        queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
        queryService.addParam(name="status", value=true, cfsqltype="CF_SQL_BIT");
        result = queryService.execute(sql="SELECT COUNT(*) AS numrows FROM subscriber_list WHERE email = :email AND status = :status");
		checkSubscriber = result.getResult();
		checkSubscriberMetaInfo = result.getPrefix();

        if (checkSubscriber.numrows GT 0) {
            response_data.status = false;
            response_data.message = 'Email already subscribed';
            WriteOutput(serializeJSON(#response_data#));
            abort;
        }

        // Check if the email was previously unsubscribed (status = false)
        queryService.clearParams();
        queryService.setName("checkSubscriberFalseStatus");
        queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
        queryService.addParam(name="status", value=false, cfsqltype="CF_SQL_BIT");
        result = queryService.execute(sql="SELECT COUNT(*) AS numrows FROM subscriber_list WHERE email = :email AND status = :status");
		checkSubscriberFalseStatus = result.getResult();
		checkSubscriberFalseStatusMetaInfo = result.getPrefix();

        if (checkSubscriberFalseStatus.numrows GT 0) {
            // Update the status to resubscribe
            queryService.clearParams();
            queryService.setName("updateSubscriberStatusTrue");
            queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
            result = queryService.execute(sql="UPDATE subscriber_list SET status = true WHERE email = :email");
            updateSubscriberStatusTrue = result.getResult();
            updateSubscriberStatusTrueMetaInfo = result.getPrefix();

            response_data.status = true;
            response_data.message = 'Email resubscribed successfully';
            WriteOutput(serializeJSON(#response_data#));
            abort;
        }

        now = Now();
        queryService.clearParams();
        queryService.setName("SubscriberStatusSuccess");
        queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
        queryService.addParam(name="status", value=true, cfsqltype="CF_SQL_BIT");
        queryService.addParam(name="created_at", value=now, cfsqltype="CF_SQL_TIMESTAMP");
        queryService.addParam(name="updated_at", value=now, cfsqltype="CF_SQL_TIMESTAMP");
        result = queryService.execute(sql="INSERT INTO subscriber_list(email, status, created_at, updated_at) 
                                            VALUES(:email, :status, :created_at, :updated_at)");
        SubscriberStatusSuccess = result.getResult();
        SubscriberStatusSuccessMetaInfo = result.getPrefix();

        response_data.status = true;
        response_data.message = 'Email subscribed successfully';
        WriteOutput(serializeJSON(#response_data#))
    }
</cfscript>