<cfinclude template="includes/session.cfm">


<cfset id = structKeyExists(FORM, 'id') ? FORM.id : 0>


<cfset output = structNew()>
<cfset output['list'] = ''>

<cfquery name="sales" datasource="fashion" RETURNTYPE="array">
    SELECT * FROM details 
    LEFT JOIN products ON products.id=details.product_id 
    LEFT JOIN sales ON sales.id=details.sales_id 
    WHERE details.sales_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
</cfquery>


<cfset total = 0>


<cfloop array="#sales#" index="sale">
    
    <cfset output['transaction'] = sale.pay_id>
    <cfset output['date'] = dateFormat(sale.sales_date, 'M dd, yyyy')>

    
    <cfset subtotal = sale.price * sale.quantity>

   
    <cfset total += subtotal>

   
    <cfset output['list'] &= "
        <tr class='prepend_items'>
            <td>#sale.name#</td>
            <td>&##36; #numberFormat(sale.price, '9.99')#</td>
            <td>#sale.quantity#</td>
            <td>&##36; #numberFormat(subtotal, '9.99')#</td>
        </tr>
    ">
</cfloop>

<cfset output['total'] = '<b>&##36; #numberFormat(total, '9.99')#<b>'>


<cfset outputJSON = serializeJSON(output)>
<cfoutput>#outputJSON#</cfoutput>