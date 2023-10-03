<cfinclude template="includes/session.cfm">

<cfparam name="form.photo" default="">
<cfif structKeyExists(form, "photo") and structKeyExists(form, "id") and structKeyExists(form, "upload")>
    <cfset id = form.id>
    <cfset filename = form.photo>

    <cfquery name="Product" datasource="fashion">
        SELECT * FROM products WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>
    
    <cfset row = Product>

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
        <cfquery name="updateProduct" datasource="fashion">
            UPDATE products
            SET photo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uploadFile#">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>
        <cfset session.success = 'Product photo updated successfully'>
    <cfcatch type="any">
        <cfset session.error = cfcatch.message>
    </cfcatch>
    </cftry>

    <cflocation url="products.cfm">
</cfif>
