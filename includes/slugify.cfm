<cffunction name="slugify" access="public" returntype="string">
    <cfargument name="string" type="string" required="true">
    
    <cfset  preps = ["in", "at", "on", "by", "into", "off", "onto", "from", "to", "with", "a", "an", "the", "using", "for"]>
    <cfset  pattern = "\b(" & ArrayToList(preps, "|") & ")\b" >
    <cfset  result = ReReplace(arguments.string, pattern, "", "all", "ignoreCase")>
    
    <cfset result = REReplace(result, "[^\pL\d]+", "-", "ALL")>
    <cfset result = LTrim(RTrim(result, "-"), "-")>
    <cfset result = CharsetEncode(result, "utf-8", "us-ascii//TRANSLIT")>
    <cfset result = LCase(result)>
    <cfset result = REReplace(result, "[^-\w]+", "", "ALL")>
    
    <cfreturn result>
</cffunction>
