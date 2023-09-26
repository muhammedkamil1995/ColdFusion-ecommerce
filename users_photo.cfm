<cfinclude template="includes/session.cfm"> 
<cfparam name="form.upload" default="">
<cfif structKeyExists(form, "photo") and structKeyExists(form, "id")>	
    <cfset id = form.id >

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
        <cfquery name="getUsersPhoto" datasource="fashion">
            SELECT photo from users WHERE
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>
        <cfif isDefined("getUsersPhoto.photo") and len(trim(getUsersPhoto.photo)) GT 0>
            <cfset deletedFile = upload.SERVERDIRECTORY & "\" & getUsersPhoto.photo>
            <cffile action="delete" file="#deletedFile#"> 
        </cfif>
        <cfquery name="users" datasource="fashion">
            UPDATE users
            SET photo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uploadFile#">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>
        <cfset session.success = 'User photo updated successfully'>
        </cfif>
    <cfcatch type="any">
        <cfset session.error = cfcatch.message>
    </cfcatch>
    </cftry>

    <cflocation url="users.cfm">
</cfif>
