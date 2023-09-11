<cfinclude template="includes/session.cfm"> 
<cfif structKeyExists(session, "user")>
	<cfset structDelete(session, "user")>
    <cflocation url="index.cfm">
<cfelse>
    <cflocation url="index.cfm">
</cfif>


