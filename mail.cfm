<cfscript>
    // Include the session or create a session as needed
     include 'includes/session.cfm';

    if (CGI.REQUEST_METHOD EQ "POST") {
        if (structKeyExists(form, "submit")) {
            name = trim(form.name);
            email = trim(form.email);
            subject = trim(form.subject);
            message = trim(form.message);

            session.name = name;
            session.email = email;
            session.subject = subject;
            session.message = message;

            if (len(name) EQ 0) {
                session.error = 'Name is required';
                location(url="contact.cfm");
            }

            if (not reFind("^[a-zA-Z-' ]*$", name)) {
                session.error = 'Name must contain only letters';
                location(url="contact.cfm");
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

            messagemain = "
                <h2>Contact Form Enquiry</h2>
                <p>Your information was delivered successfully:</p>
                <p>Email: #email#</p>
                <p>Subject: #subject#</p>
                <p>Name: #name#</p>
                <p>Message: #message#</p>
                <a href='#base_url#/ecommerce/'>Login</a>
            ";

            subjectmain = 'Contact us issue';
            sessionVariables = ['email', 'name', 'subject', 'message'];
            success = 'Message Sent successfully.';
            error = 'Message could not be sent. Mailer Error: ';
            redirect_success = 'contact.cfm';

            // Call the mail_sender function to send the email
                    subject = 'Welcome to Afric Comm'
                    mailFrom = 'kamzyocoded@gmail.com'
                    mailerService = new mail();
                    mailerService.setServer('smtp.gmail.com');
                    mailerService.setUsername(mailFrom);
                    mailerService.setPassword('vqrpuldbikmeyrfu');
                    mailerService.setPort(465);
                    mailerService.setTo(email);
                    mailerService.setFrom(mailFrom);
                    mailerService.setSubject(subject);
                    mailerService.setType("html");
                    mailerService.send(body=message);

            // Redirect to a success page or display a success message here 
            location(url="#redirect_success#");
        }
    }
</cfscript>
