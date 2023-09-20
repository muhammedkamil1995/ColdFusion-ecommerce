<cfscript>
    // Include the session or create a session as needed
     include 'includes/session.cfm';

    if (CGI.REQUEST_METHOD EQ "POST") {
        if (structKeyExists(form, "contact-us")) {
            name = trim(form.name);
            email = trim(form.email);
            subject = trim(form.subject);
            message = trim(form.message);
            // CGI.REMOTE_ADDR, REMOTE_HOST, SERVER_NAME 127.0.0.1
            // writeDump(CGI.SERVER_PROTOCOL);
            // exit;

            session.name = name;
            session.email = email;
            session.subject = subject;
            session.message = message;

            if (len(name) EQ 0) {
                session.error = 'Name is required';
                location(url="contact.cfm");
                exit
            }

            if (not reFind("^[a-zA-Z-' ]*$", name)) {
                session.error = 'Name must contain only letters';
                location(url="contact.cfm");
                exit
            }

            if (len(name) GT 20) {
                session.error = 'Name can not be more than 20 characters';
                location(url="contact.cfm");
            }

            if (len(name) LT 3) {
                session.error = 'Name can not be less than 3 characters';
                location(url="contact.cfm");
            }

            if (len(email) EQ 0) {
                session.error = 'Email is required';
                location(url="contact.cfm");
            }

            if (not isValid("email", email)) {
                session.error = 'Invalid email format';
                location(url="contact.cfm");
            }

            if (len(subject) EQ 0) {
                session.error = 'Subject is required';
                location(url="contact.cfm");
            }

            if (len(subject) GT 50) {
                session.error = 'Subject can not be more than 50 characters';
                location(url="contact.cfm");
            }

            if (len(subject) LT 3) {
                session.error = 'Subject can not be less than 3 characters';
                location(url="contact.cfm");
            }

            if (len(message) EQ 0) {
                session.error = 'Message must contain some information';
                location(url="contact.cfm");
            }

            if (len(message) GT 1000) {
                session.error = 'Message can not be more than 1000 characters';
                location(url="contact.cfm");
            }

            if (len(message) LT 5) {
                session.error = 'Message can not be less than 5 characters';
                location(url="contact.cfm");
            }

            subject = 'Welcome to Afric Comm: Contact us issue';


            base_url = CGI.REMOTE_ADDR

            // Email content
            messagemain = "
                <h2>Contact Form Enquiry</h2>
                <p>Your information was delivered successfully:</p>
                <p>Email: #email#</p>
                <p>Subject: #subject#</p>
                <p>Name: #name#</p>
                <p>Message: #message#</p>
                <a href='#base_url#/ecommerce/'>Login</a>
            ";
            redirect_success = "contact.cfm"

        

            

            try {
                // Create a cfhttp object
                cfhttp = new http();


                // Set the URL and method
                cfhttp.setURL("http://127.0.0.1:4000/mail/contactmail");
                cfhttp.setMethod("POST");



                // Set the form fields
                cfhttp.addParam(type="formfield", name="email", value=email);
                cfhttp.addParam(type="formfield", name="message", value=messagemain);
                cfhttp.addParam(type="formfield", name="subject", value=subject);

                // Execute the HTTP request
                response = cfhttp.send();
                // Writeoutput(cfhttp.filecontent);
                session.success = 'Message Sent successfully.';
            } catch (any e) {
                session.error = 'Message could not be sent. Mailer Error: ' & e.getMessage();
            }

            // Redirect to a success page or display a success message here 
            location(url="#redirect_success#");
        }
    }
</cfscript>
