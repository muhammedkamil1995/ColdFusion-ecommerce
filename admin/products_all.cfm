<cfinclude template="includes/session.cfm">

<cfset output = "">

<cfset conn = application.pdo.open()>

<cfquery name="stmt" datasource="#dsn#">
	SELECT * FROM products
</cfquery>

<cfloop query="stmt">
	<cfset output &= "<option value='#id#' class='append_items'>#name#</option>">
</cfloop>

<cfset application.pdo.close()>

<cfoutput>#serializeJSON(output)#</cfoutput>
