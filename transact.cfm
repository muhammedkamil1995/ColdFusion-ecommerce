<!-- Include session configuration and functions -->
<cfinclude template="includes/session.cfm">

<!-- Get the sales transaction ID from the POST data -->
<cfset id = structKeyExists(FORM, 'id') ? FORM.id : 0>



<!-- Initialize an array to store output data -->
<cfset output = structNew()>
<cfset output['list'] = ''>

<!-- Prepare and execute a database query to fetch transaction details -->
<cfquery name="products" datasource="fashion">
    SELECT *, sales.id AS salesid
    FROM details
    LEFT JOIN products ON products.id = details.product_id
    LEFT JOIN sales ON sales.id = details.sales_id
    WHERE details.sales_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
</cfquery>


<!-- Initialize a variable to store the total transaction amount -->
<cfset total = 0>

<!-- Loop through the fetched rows -->
<cfloop array="#sales#" index="sale">
    <!-- Store payment ID and sales date -->
    <cfset output['transaction'] = pay_id>
    <cfset output['date'] = dateFormat(sales_date, 'M dd, yyyy')>

    <!-- Calculate the subtotal for the current product -->
    <cfset subtotal = row.price * row.quantity>

    <!-- Update the total by adding the subtotal -->
    <cfset total += subtotal>

    <!-- Construct a table row for the product details -->
    <cfset output['list'] &= "
        <tr class='prepend_items'>
            <td>#stmt.name#</td>
            <td>&#36; #numberFormat(stmt.price, '9.99')#</td>
            <td>#stmt.quantity#</td>
            <td>&#36; #numberFormat(subtotal, '9.99')#</td>
        </tr>
    ">
</cfloop>

<!-- Store the total transaction amount in the output array -->
<cfset output['total'] = '<b>&##36; #numberFormat(total, '9.99')#<b>'>

<

<!-- Convert the output struct to JSON format -->
<cfset outputJSON = serializeJSON(output)>
<cfoutput>#outputJSON#</cfoutput>


