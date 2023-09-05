<cfinclude template="includes/session.cfm"> 


<cfif structKeyExists(form, "edit")>
    <cfset curr_password = form.curr_password>
    <cfset email = form.email>
    <cfset password = form.password>
    <cfset firstname = form.firstname>
    <cfset lastname = form.lastname>
    <cfset contact = form.contact>
    <cfset address = form.address>
    <cfset photo = form.photo>
    
    <cfif compare(password_verify(curr_password, user.password), true)>
        <cfif isDefined("form.photo") and !isEmpty(form.photo)>
            <cfset filename = "images/#form.photo#">
            <cffile action="upload" filefield="form.photo" destination="images" nameconflict="overwrite">
        <cfelse>
            <cfset filename = user.photo>
        </cfif>
        
        <cfif password == user.password>
            <cfset password = user.password>
        <cfelse>
            <cfset password = hash(password, "SHA-256")>
        </cfif>
        
        <cftry>
            <cfquery name="updateUser" datasource="fashion">
                UPDATE users
                SET email = :email, password = :password, firstname = :firstname, lastname = :lastname, contact_info = :contact, address = :address, photo = :photo
                WHERE id = :id
            </cfquery>
            
            <cfset updateUserParams = {
                email: email,
                password: password,
                firstname: firstname,
                lastname: lastname,
                contact: contact,
                address: address,
                photo: filename,
                id: user.id
            }>
            
            <cftransaction>
                <cfquery name="updateUser" datasource="fashion">
                    UPDATE users
                    SET email = :email, password = :password, firstname = :firstname, lastname = :lastname, contact_info = :contact, address = :address, photo = :photo
                    WHERE id = :id
                </cfquery>
            </cftransaction>
            
            <cfset session.success = 'Account updated successfully'>
        <cfcatch type="database">
            <cfset session.error = 'Database error: #cfcatch.message#'>
        </cfcatch>
        </cftry>
    <cfelse>
        <cfset session.error = 'Incorrect password'>
    </cfif>
<cfelse>
    <cfset session.error = 'Fill up edit form first'>
</cfif>



<cflocation url="profile.cfm">


	