<cfinclude template="includes/session.cfm">

<cffunction name="generateRow" returntype="string" output="false">
    <cfargument name="from" type="date" required="true">
    <cfargument name="to" type="date" required="true">
    <cfargument name="conn" type="any" required="true">

    <cfset contents = "">
    
    <cfquery name="salesQuery" datasource="#application.dsn#">
        SELECT sales.*, users.firstname, users.lastname
        FROM sales
        LEFT JOIN users ON users.id = sales.user_id
        WHERE sales.sales_date BETWEEN <cfqueryparam value="#from#" cfsqltype="cf_sql_date">
            AND <cfqueryparam value="#to#" cfsqltype="cf_sql_date">
        ORDER BY sales.sales_date DESC
    </cfquery>
    
    <cfset total = 0>
    
    <cfloop query="salesQuery">
        <cfquery name="detailsQuery" datasource="#application.dsn#">
            SELECT details.*, products.price
            FROM details
            LEFT JOIN products ON products.id = details.product_id
            WHERE details.sales_id = <cfqueryparam value="#salesQuery.salesid#" cfsqltype="cf_sql_integer">
        </cfquery>
        
        <cfset amount = 0>
        
        <cfloop query="detailsQuery">
            <cfset subtotal = detailsQuery.price * detailsQuery.quantity>
            <cfset amount = amount + subtotal>
        </cfloop>
        
        <cfset total = total + amount>
        
        <cfset contents = contents & '
        <tr>
            <td>#dateFormat(salesQuery.sales_date, "MMM dd, yyyy")#</td>
            <td>#salesQuery.firstname# #salesQuery.lastname#</td>
            <td>#salesQuery.pay_id#</td>
            <td align="right">&#36; #numberFormat(amount, "9.99")#</td>
        </tr>
        '>
    </cfloop>
    
    <cfset contents = contents & '
        <tr>
            <td colspan="3" align="right"><b>Total</b></td>
            <td align="right"><b>&#36; #numberFormat(total, "9.99")#</b></td>
        </tr>
    '>
    
    <cfreturn contents>
</cffunction>

<cfif structKeyExists(form, "print")>
    <cfset ex = listToArray(form.date_range, " - ")>
    <cfset from = createDate(year(ex[1]), month(ex[1]), day(ex[1]))>
    <cfset to = createDate(year(ex[2]), month(ex[2]), day(ex[2]))>
    <cfset from_title = dateFormat(from, "MMM dd, yyyy")>
    <cfset to_title = dateFormat(to, "MMM dd, yyyy")>

    <cfquery name="salesConn" datasource="#application.dsn#">
        SELECT sales.*, users.firstname, users.lastname
        FROM sales
        LEFT JOIN users ON users.id = sales.user_id
    </cfquery>

    <cfdocument format="PDF">
        <cfoutput>
            <h2 align="center">TechSoft IT Solutions</h2>
            <h4 align="center">SALES REPORT</h4>
            <h4 align="center">#from_title# - #to_title#</h4>
            <table border="1" cellspacing="0" cellpadding="3">
                <tr>
                    <th width="15%" align="center"><b>Date</b></th>
                    <th width="30%" align="center"><b>Buyer Name</b></th>
                    <th width="40%" align="center"><b>Transaction#</b></th>
                    <th width="15%" align="center"><b>Amount</b></th>
                </tr>
                #generateRow(from, to, salesConn)#
            </table>
        </cfoutput>
    </cfdocument>
</cfif>
