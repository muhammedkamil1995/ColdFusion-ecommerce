<cfinclude template="includes/session.cfm">

<cfset output = "">
<cfset conn = pdo.open()>

<cfquery name="getCategories" datasource="#dsn#">
    SELECT * FROM category
</cfquery>

<cfloop query="getCategories">
    <cfset output &= "
        <option value='#id#' class='append_items'>#name#</option>
    ">
</cfloop>

<cfset pdo.close()>
<cfoutput>#output#</cfoutput>
