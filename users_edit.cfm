<cfinclude template="includes/session.cfm"> 
<cfparam name="form.edit" default="">
<cfif structKeyExists(form, "edit")>
    <cfset id = form.id>
    <cfset firstname = form.firstname>
    <cfset lastname = form.lastname>
    <cfset email = form.email>
    <cfset password = form.password>
    <cfset address = form.address>
    <cfset contact = form.contact>

    <cftry>
        <cfif isDefined('password') and Trim(len(password)) GT 5 >
            <cfscript> 
                options = StructNew() 
                options.rounds = 4 
                options.version = "$2a" 
            </cfscript>
            <cfset hashPassword = GenerateBCryptHash(password, options)>

            <cfquery name="editUsers" datasource="fashion">
                UPDATE users
                SET email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashPassword#">,
                    firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#firstname#">,
                    lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lastname#">,
                    address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#address#">,
                    contact_info = <cfqueryparam cfsqltype="cf_sql_varchar" value="#contact#">
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
            </cfquery>
        <cfelse>

            <cfquery name="editUsers" datasource="fashion">
                UPDATE users
                SET email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
                    firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#firstname#">,
                    lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lastname#">,
                    address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#address#">,
                    contact_info = <cfqueryparam cfsqltype="cf_sql_varchar" value="#contact#">
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
            </cfquery>
        </cfif>
        
        <cfset session.success = "User updated successfully">
    <cfcatch type="any">
        <cfset session.error = cfcatch.message>
    </cfcatch>
    </cftry>

<cflocation url="users.cfm">
</cfif>
