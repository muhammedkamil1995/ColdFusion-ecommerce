<cfscript>
    // Include necessary template
    include 'includes/session.cfm';

    // Check if 'id' key exists in the form
    if (structKeyExists(form, "id")) {
        // Get the 'id' value from the form
        id = form.id;

        try {
            // Create a query using queryService
            queryService = new query();
            queryService.setDatasource("fashion");
            queryService.setSql("SELECT products.*, products.id AS prodid, products.name AS prodname, category.name AS catname FROM products LEFT JOIN category ON category.id = products.category_id WHERE products.id = :id");
            queryService.addParam(name="id", value=id, cfsqltype="cf_sql_integer");

            // Execute the query
            queryResult = queryService.execute();

            // Check if any rows were returned
            if (queryResult.recordCount > 0) {
                // Get the first row as a struct
                row = queryResult.getRecord(1);

                // Serialize the struct to JSON
                serializedRow = serializeJSON(row);

                // Output the serialized JSON
                writeOutput(serializedRow);
            } else {
                // Output an empty JSON object if no rows were found
                writeOutput("{}");
            }
        } catch (any e) {
            // Handle exceptions, e.g., log the error
            writeOutput("Error: " & e.getMessage());
        }
    }
</cfscript>
