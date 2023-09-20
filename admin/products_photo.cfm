<cfscript>
    // Include necessary templates
    include 'includes/session.cfm';
    include 'includes/slugify.cfm';

    // Check if 'edit' key exists in the form
    if (structKeyExists(form, "edit")) {
        // Get form data
        id = form.id;
        name = form.name;
        slug = slugify(name);
        category = form.category;
        price = form.price;
        description = form.description;

        try {
            
            // Create a query using queryService
            queryService = new query();
            queryService.setDatasource("fashion");
            queryService.setSql("UPDATE products SET name = :name, slug = :slug, category_id = :category, price = :price, description = :description WHERE id = :id");
            queryService.addParam(name="name", value=name, cfsqltype="cf_sql_varchar");
            queryService.addParam(name="slug", value=slug, cfsqltype="cf_sql_varchar");
            queryService.addParam(name="category", value=category, cfsqltype="cf_sql_integer");
            queryService.addParam(name="price", value=price, cfsqltype="cf_sql_decimal");
            queryService.addParam(name="description", value=description, cfsqltype="cf_sql_longvarchar");
            queryService.addParam(name="id", value=id, cfsqltype="cf_sql_integer");

            // Execute the query
            queryResult = queryService.execute();

            // Check if the update was successful
            if (queryResult) {
                session.success = "Product updated successfully";
            } else {
                session.error = "Failed to update product";
            }
        } catch (any e) {
            // Handle exceptions
            session.error = e.getMessage();
        }
    } else {
        session.error = "Fill up edit product form first";
    }

    // Redirect to 'products.cfm'
    location(url="products.cfm");
</cfscript>
