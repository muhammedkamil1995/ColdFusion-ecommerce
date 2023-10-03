<cfinclude template="includes/session.cfm">
<cfinclude template="includes/slugify.cfm">
<cfparam name="form.add" default="">
<cfif structKeyExists(form, "add")>
    <cfset name = form.name>
    <cfset category = form.category>
    <cfset price = form.price>
    <cfset description = form.description>
    <cfset filename = form.photo>
    <cfset slug = slugify(name)>

    <cfquery name="checkProduct" datasource="fashion">
        SELECT *, COUNT(*) AS numrows FROM products WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
    </cfquery>
    
    <cfset row = checkProduct>

    <cfif row.numrows GT 0>
        <cfset session.error = 'Product already exists'>
    <cfelse>
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

            <cfif not structKeyExists(session, 'error')>
                <cfquery name="insertProduct" datasource="fashion">
                    INSERT INTO products (category_id, name, description, slug, price, photo)
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#category#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#slug#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#price#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#uploadFile#">
                    )
                </cfquery>
                <cfset session.success = 'Product added successfully'>
            </cfif>
        </cftry>
    </cfif>

    <cflocation url="products.cfm">
</cfif>
