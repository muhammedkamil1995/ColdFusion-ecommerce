<cfinclude template="includes/session.cfm">

<cfset output = "">

<cfquery name="category" datasource="fashion">
    SELECT * FROM category
</cfquery>

<cfoutput query="category">
    <cfset output &= " <option value='#id#' class='append_items'>#name#</option>">
</cfoutput>

<cfoutput>#output#</cfoutput>
