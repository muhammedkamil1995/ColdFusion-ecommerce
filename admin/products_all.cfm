<cfscript>
    include 'includes/session.cfm';

    output = [];
    queryService = new query();
    queryService.setDatasource("fashion");
    queryService.setName("stmt");
    queryService.setSql("SELECT * FROM products");
    result = queryService.execute();

    for (row in result.getResult()) {
        arrayAppend(output, {
            "value": row.id,
            "class": "append_items",
            "name": row.name
        });
    }

    WriteOutput(serializeJSON(output));
</cfscript>

