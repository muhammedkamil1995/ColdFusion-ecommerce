<cfscript>
    include 'includes/session.cfm';

    if (CGI.REQUEST_METHOD EQ "POST") {
        // Decode JSON data from the request
        requestData = deserializeJSON(toString(getHttpRequestData().content));

        email = trim(requestData.email);
        if (len(email) EQ 0) {
            response_data = {
                'status': false,
                'message': 'Email is required'
            };
            WriteOutput(serializeJSON(response_data));
            abort;
        }

        if (!isValid("email", email)) {
            response_data = {
                'status': false,
                'message': 'Invalid email format'
            };
            WriteOutput(serializeJSON(response_data));
            abort;
        }


        // Check if the email is already subscribed (status = true)
        queryService = new query();
        queryService.setDatasource("fashion"); // Set your actual datasource name
        queryService.setName("checkSubscriber");
        queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
        queryService.addParam(name="status", value=true, cfsqltype="CF_SQL_BIT");
        queryService.setSQL("SELECT COUNT(*) AS numrows FROM subscriber_list WHERE email = :email AND status = :status");
        queryService.execute();

        row = queryService.getResult().firstRow;
        if (row.numrows GT 0) {
            response_data = {
                'status': false,
                'message': 'Email already subscribed'
            };
            WriteOutput(serializeJSON(response_data));
            queryService.close();
            abort;
        }

        // Check if the email was previously unsubscribed (status = false)
        queryService.clearParams();
        queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
        queryService.addParam(name="status", value=false, cfsqltype="CF_SQL_BIT");
        queryService.setSQL("SELECT COUNT(*) AS numrows FROM subscriber_list WHERE email = :email AND status = :status");
        queryService.execute();

        row = queryService.getResult().firstRow;
        if (row.numrows GT 0) {
            // Update the status to resubscribe
            queryService.clearParams();
            queryService.setSQL("UPDATE subscriber_list SET status = true WHERE email = :email");
            queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
            queryService.execute();

            response_data = {
                'status': true,
                'message': 'Email resubscribed successfully'
            };
            WriteOutput(serializeJSON(response_data));
            queryService.close();
            abort;
        }

        // Insert a new subscription record
        now = createDateTime();
        queryService.clearParams();
        queryService.setSQL("
            INSERT INTO subscriber_list (email, status, created_at, updated_at) 
            VALUES (:email, :status, :created_at, :updated_at)
        ");
        queryService.addParam(name="email", value=email, cfsqltype="CF_SQL_VARCHAR");
        queryService.addParam(name="status", value=true, cfsqltype="CF_SQL_BIT");
        queryService.addParam(name="created_at", value=now, cfsqltype="CF_SQL_TIMESTAMP");
        queryService.addParam(name="updated_at", value=now, cfsqltype="CF_SQL_TIMESTAMP");
        queryService.execute();

        response_data = {
            'status': true,
            'message': 'Email subscribed successfully'
        };
        WriteOutput(serializeJSON(response_data));
        queryService.close();
    }
</cfscript>