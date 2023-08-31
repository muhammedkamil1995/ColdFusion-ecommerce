<cfinclude template="../includes/conn.cfc">
<cfset session.admin = PreserveSingleQuotes(session.admin)>

<cfif NOT StructKeyExists(session, "admin") OR Trim(session.admin) EQ "">
    <cflocation url="../index.cfm" addtoken="false">
    <cfabort>
</cfif>

<cfset conn = Application.conn>
<cfset stmt = conn.prepareStatement("SELECT * FROM users WHERE id=:id")>
<cfset stmt.setSQLParameters({id: session.admin})>
<cfset admin = stmt.executeQuery().getOne()>

<cfset stmt.close()>
<cfset conn.close()>
