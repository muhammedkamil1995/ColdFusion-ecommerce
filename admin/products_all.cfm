<cfinclude template="includes/session.cfm">

<cfset output = "">

<cftry>
    <cfquery name="getProducts" datasource="fashion">
        SELECT * FROM products
    </cfquery>
    <cfoutput query="getProducts">
        <cfset output &= "<option value='#getProducts.id#' class='append_items'>#getProducts.name#</option>">
    </cfoutput>

    <cfcatch type="any">
        <cfset output &= "An error occurred: #cfcatch.message#">
    </cfcatch>
</cftry>

<cfoutput>#output#</cfoutput>
