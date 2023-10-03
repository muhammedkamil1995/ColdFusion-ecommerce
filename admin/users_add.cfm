<cfinclude template="includes/session.cfm"> 
<cfparam name="form.add" default="">
<cfif structKeyExists(form, "add")>
    <cfset firstname = form.firstname>
    <cfset lastname = form.lastname>
    <cfset email = form.email>
    <cfset password = form.password>
    <cfset address = form.address>
    <cfset contact = form.contact>

    <cfquery name="getUsers" datasource="fashion">
        SELECT COUNT(*) AS numrows
        FROM users
        WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
    </cfquery>

    <cfif getUsers.numrows gt 0>
        <cfset session.error = 'Email already taken'>
    <cfelse>
        <cfscript> 
            options = StructNew() 
            options.rounds = 4 
            options.version = "$2a" 
        </cfscript>
        <cfset hashPassword = GenerateBCryptHash(password, options)>
        <cfset filename = form.photo>
        <cfset now = dateFormat(now(), "yyyy-mm-dd")>

        <cfif isDefined("form.photo") and len(trim(form.photo)) gt 0 and structKeyExists(form, "photo") && len(trim(form.photo))>
            <cfset filename = expandpath('../images/')>

            <cftry>
                <cffile action="upload" filefield="form.photo" destination="#filename#" 
                nameconflict="MAKEUNIQUE" accept="image/jpg,image/jpeg,image/png,image/gif" 
                allowedExtensions=".png,.jpg,.jpeg,.gif" result="upload">
            <cfcatch type="any">
                <cfif FindNoCase( "No data was received in the uploaded", cfcatch.message )>
                    <cfset session.error = "Zero length file">

                <!--- prevent invalid file types --->
                <cfelseif FindNoCase( "The MIME type or the Extension of the uploaded file", cfcatch.message )>
                    <cfset session.error = "Invalid file type">

                <!--- prevent empty form field --->
                <cfelseif FindNoCase( "did not contain a file.", cfcatch.message )>
                    <cfset session.error = "Empty form field">

                <!---all other errors --->
                <cfelse>
                    <cfset session.error = "Unhandled File Upload Error">

                </cfif>
            </cfcatch>
            </cftry>

            <cfif isDefined("upload") and not listFindNoCase("jpg,jpeg,png,gif", upload.serverFileExt)>
                <cffile action="delete" file="#upload.ServerDirectory#/#upload.ServerFile#" >
                <cfset session.error = "Invalid file type (checked)">
            </cfif>

            <!-- Check the file size (not more than 5MB) -->
            <cfif isDefined("upload") and upload.fileWasSaved>
                <cfset newFileName = createUUID() & "." & upload.SERVERFILEEXT>
                <cfset renameFile = upload.SERVERDIRECTORY & "\" & newFileName>
                <cfset uploadFile = upload.SERVERDIRECTORY & "\" & upload.SERVERFILE>
                <cfif not isImageFile(uploadFile)>
                    <cfset session.error = "Please include a VALID picture">
                    <cffile action="delete" file="#uploadFile#"> 
                <cfelseif upload.filesize gt 5000000 >
                    <cfset session.error = "Your image cannot be larger than 5MB!">
                <cfelse>
                    <cffile action="rename" source="#uploadFile#" destination="#renameFile#" attributes="normal" result="rename">
                </cfif>
            </cfif>
        </cfif>

        <cfif not isDefined("newFileName")>
            <cfset uploadFile = ''>
        <cfelse>
            <cfset uploadFile = newFileName>
        </cfif>

        <cftry>
            <cfif not structKeyExists(session, 'error') >
                <cfquery name="addUser" datasource="fashion">
                    INSERT INTO users (email, password, firstname, lastname, address, contact_info, photo, status, created_on)
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashPassword#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#firstname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#lastname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#contact#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#uploadFile#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now#">
                    )
                </cfquery>
                <cfset session.success = 'User added successfully'>
            </cfif>
        <cfcatch type="any">
            <cfset session.error = cfcatch>
        </cfcatch>
        </cftry>
    </cfif>

    <cflocation url="users.cfm">
</cfif>