<cfscript>
    include 'includes/session.cfm';
    include 'includes/slugify.cfm';

    if (structKeyExists(form, "add")) {
        // Get form data
        name = form.name;
        slug = slugify(name);
        category = form.category;
        price = form.price;
        description = form.description;
        filename = form.photo;

        // Check if the product already exists
        queryService = new query();
        queryService.setDatasource("fashion");
        sqlCheckProduct = "
            SELECT *, COUNT(*) AS numrows
            FROM products
            WHERE slug = :slug
        ";
        queryService.addParam(name="slug", value=slug, cfsqltype="cf_sql_varchar");
        result = queryService.execute(sql=sqlCheckProduct);
        row = result.getResult()[1];

        if (row.numrows GT 0) {
            session.error = "Product already exists";
        } else {
            if (len(trim(filename)) EQ 0) {
                new_filename = "";
            } else {
                ext = listLast(filename, ".");
                new_filename = slug & "." & ext;
                fileResult = fileUpload(destination="../images/", fileField="photo", nameConflict="makeUnique");
                if (fileResult.STATUS EQ "OK") {
                    new_filename = fileResult.SERVERFILE;
                }
            }

            try {
                queryService = new query();
                queryService.setDatasource("fashion");
                sqlInsertProduct = "
                    INSERT INTO products (category_id, name, description, slug, price, photo)
                    VALUES (
                        :category,
                        :name,
                        :description,
                        :slug,
                        :price,
                        :new_filename
                    )
                ";
                queryService.addParam(name="category", value=category, cfsqltype="cf_sql_integer");
                queryService.addParam(name="name", value=name, cfsqltype="cf_sql_varchar");
                queryService.addParam(name="description", value=description, cfsqltype="cf_sql_varchar");
                queryService.addParam(name="slug", value=slug, cfsqltype="cf_sql_varchar");
                queryService.addParam(name="price", value=price, cfsqltype="cf_sql_decimal");
                queryService.addParam(name="new_filename", value=new_filename, cfsqltype="cf_sql_varchar");
                queryService.execute(sql=sqlInsertProduct);
                session.success = "Product added successfully";
            } catch (any e) {
                session.error = e.message;
            }
        }
    } else {
        session.error = "Fill up the product form first";
    }

    location(url="products.cfm");
</cfscript>










