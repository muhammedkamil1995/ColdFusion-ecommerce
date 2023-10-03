<cfinclude template="includes/session.cfm">
<cfif structKeyExists(form, "delete")>
    <cfset id = form.id>

    <cftry>
        <cfquery name="deleteProduct" datasource="fashion">
            DELETE FROM products WHERE id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id#">
        </cfquery>
        <cfset session.success = 'Product deleted successfully'>
    <cfcatch type="any">
        <cfset session.error = cfcatch.message>
    </cfcatch>
    </cftry>

    <cflocation url="products.cfm">
</cfif>
