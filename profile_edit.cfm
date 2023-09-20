<cfscript>
    include 'includes/session.cfm'

    if (CGI.REQUEST_METHOD EQ "POST") {

        if( not structKeyExists(session, "user") ) {
            location(url="index.cfm")
        }
    
        if (structKeyExists(form, "edit")) {
            curr_password = form.curr_password;
            email = form.email;
            firstname = form.firstname;
            lastname = form.lastname;
            contact = form.contact;
            address = form.address;
            photo = form.photo;
            
            // Check if the entered current password matches the user's current password
            if ( VerifyBCryptHash(curr_password, getUserResult.password)) {
                // Check if a new photo is uploaded
                if ( structKeyExists(form, "photo") && len(trim(form.photo)) ) {
                    // Move the uploaded photo to the destination folder
                    destFolder = expandPath("images/"); 
                    allowedMimeTypes = "image/jpg,image/jpeg,image/png,image/gif";
                    allowedExtensions = ".png,.jpg,.jpeg,.gif";
                    fileUploadResult = fileUpload(destFolder, "photo", allowedMimeTypes, "MakeUnique", true, allowedExtensions);

                    newFileName = createUUID() & "." &fileUploadResult.SERVERFILEEXT
                    renameFile = fileUploadResult.SERVERDIRECTORY& "\" & newFileName
                    uploadFile = fileUploadResult.SERVERDIRECTORY& "\" & fileUploadResult.SERVERFILE

                    cffile(action = "rename" , destination = "#renameFile#" , source = "#uploadFile#" , attributes = "normal" )


                    if (not listFindNoCase("jpg,jpeg,png,gif", fileUploadResult.serverFileExt)) {
                        session.error = "The uploaded file is not of type JPG.";
                        // writeDump(fileUploadResult)
                    }

                    /* if (not IsImageFile( fileUploadResult.SERVERFILE )) {
                        session.error = "Uploaded file not an image.";
                    } */
                    /* writeDump(fileUploadResult)
                    Return */

                    
                    /* try {
                        cfzip(action = "list", file = "#fileUploadResult.SERVERFILE#", name="tmp") 
                        session.error = "Embedded zip files not allowed.";
                    }
                    catch(type any) {
                        
                    } */
                    
                    if (structKeyExists(fileUploadResult, "SERVERDIRECTORY")) {
                        filename = newFileName;
                        // check if file is available getUserResult.photo
                        if( len(getUserResult.photo) > 0 ) {
                            // delete existing file
                            existingFilePath = fileUploadResult.SERVERDIRECTORY& "\" & getUserResult.photo
                            cffile(action = "delete", file = "#existingFilePath#" )
                        }
                    } else {
                        filename = getUserResult.photo;
                    }
                } else {
                    filename = getUserResult.photo;
                }

                try {
                    // Update user information in the database
                    queryService = new query();
                    queryService.setDatasource("fashion"); // Set your actual datasource name
                    queryService.setName("updateUser");
                    queryService.setSQL("
                        UPDATE users
                        SET email = :email, firstname = :firstname, lastname = :lastname, contact_info = :contact, address = :address, photo = :photo
                        WHERE id = :id
                    ");
                    queryService.addParam(name="email", value=#email#, cfsqltype="CF_SQL_VARCHAR");
                    queryService.addParam(name="firstname", value=#firstname#, cfsqltype="CF_SQL_VARCHAR");
                    queryService.addParam(name="lastname", value=#lastname#, cfsqltype="CF_SQL_VARCHAR");
                    queryService.addParam(name="contact", value=#contact#, cfsqltype="CF_SQL_VARCHAR");
                    queryService.addParam(name="address", value=#address#, cfsqltype="CF_SQL_VARCHAR");
                    queryService.addParam(name="photo", value=#filename#, cfsqltype="CF_SQL_VARCHAR");
                    queryService.addParam(name="id", value=#getUserResult.id#, cfsqltype="CF_SQL_INTEGER");
                    queryService.execute();

                    // Set a success message
                    session.success = 'Account updated successfully';
                } catch (any database) {
                    // Handle database errors
                    session.error = database.message;
                }
            } else {
                // Set an error message for incorrect password
                session.error = 'Incorrect password';
            }
        } else {
            // Set an error message for incomplete form submission
            session.error = 'Fill up the edit form first';
        }
        
    

        // Redirect to profile.cfm
        location(url="profile.cfm");
    }
</cfscript>