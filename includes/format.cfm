<cffunction name="numberFormatShort" access="public" returntype="string">
    <cfargument name="n" type="numeric" required="true">
    <cfargument name="precision" type="numeric" default="1">
    
    <cfset n_format = "">
    <cfset suffix = "">
    
    <cfif arguments.n < 900>
        <!--- 0 - 900 --->
        <cfset n_format = NumberFormat(arguments.n, arguments.precision)>
        <cfset suffix = "">
    <cfelseif arguments.n < 900000>
        <!--- 0.9k-850k --->
        <cfset n_format = NumberFormat(arguments.n / 1000, arguments.precision)>
        <cfset suffix = "K">
    <cfelseif arguments.n < 900000000>
        <!--- 0.9m-850m --->
        <cfset n_format = NumberFormat(arguments.n / 1000000, arguments.precision)>
        <cfset suffix = "M">
    <cfelseif arguments.n < 900000000000>
        <!--- 0.9b-850b --->
        <cfset n_format = NumberFormat(arguments.n / 1000000000, arguments.precision)>
        <cfset suffix = "B">
    <cfelse>
        <!--- 0.9t+ --->
        <cfset n_format = NumberFormat(arguments.n / 1000000000000, arguments.precision)>
        <cfset suffix = "T">
    </cfif>
    
    <!--- Remove unnecessary zeroes after decimal. "1.0" -> "1"; "1.00" -> "1" --->
    <!--- Intentionally does not affect partials, e.g., "1.50" -> "1.50" --->
    <cfif arguments.precision > 0>
        <cfset dotZero = "." & RepeatString("0", arguments.precision)>
        <cfset n_format = Replace(n_format, dotZero, "", "ALL")>
    </cfif>
    
    <cfreturn n_format & suffix>
</cffunction>
