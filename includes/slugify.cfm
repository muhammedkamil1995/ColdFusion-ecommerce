<cffunction name="slugify" access="public" returntype="string">
    <cfargument name="string" type="string" required="true">
    
    <cfset  preps = ["in", "at", "on", "by", "into", "off", "onto", "from", "to", "with", "a", "an", "the", "using", "for"]>
    <cfset pattern = "\b(#ArrayToList(preps, "|")#)\b">
    <cfset result = REReplaceNoCase(arguments.string, pattern, "", "ALL")>
    
    <cfset result = REReplace(result, "[^\w\d]+", "-", "ALL")>

    <cfset result = trim(REReplace(result, " ", "-", "ALL"))>
    <cfset result = LCase(result)>
    <cfset result = REReplace(result, "[^-\w]+", "", "ALL")>
    
    <cfreturn result>
</cffunction>
