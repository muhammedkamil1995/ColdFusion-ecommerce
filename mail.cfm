<cfinclude template="includes/session.cfm">

<cfif structKeyExists(form, "submit")>

    <!-- Get form inputs -->
    <cfset name = trim(form.name)>
    <cfset email = trim(form.email)>
    <cfset subject = trim(form.subject)>
    <cfset message = trim(form.message)>

    <!-- Store form inputs in session -->
    <cfset session.name = name>
    <cfset session.email = email>
    <cfset session.subject = subject>
    <cfset session.message = message>

    <!-- Validate name -->
    <cfif len(name) EQ 0>
        <cfset session.error = 'Name is required'>
        <cflocation url="contact.cfm">
    </cfif>
    
    <cfif not reFind("^[a-zA-Z-' ]*$", name)>
        <cfset session.error = 'Name must contain only letters'>
        <cflocation url="contact.cfm">
    </cfif>

    <cfif len(name) GT 20>
        <cfset session.error = 'Name can not be more than 20 characters'>
        <cflocation url="contact.cfm">
    </cfif>

    <cfif len(name) LT 3>
        <cfset session.error = 'Name can not be less than 3 characters'>
        <cflocation url="contact.cfm">
    </cfif>

    <!-- Validate email -->
    <cfif len(email) EQ 0>
        <cfset session.error = 'Email is required'>
        <cflocation url="contact.cfm">
    </cfif>

    <cfif not isValid("email", email)>
        <cfset session.error = 'Invalid email format'>
        <cflocation url="contact.cfm">
    </cfif>

    <!-- Validate subject -->
    <cfif len(subject) EQ 0>
        <cfset session.error = 'Subject is required'>
        <cflocation url="contact.cfm">
    </cfif>

    <cfif len(subject) GT 50>
        <cfset session.error = 'Subject can not be more than 50 characters'>
        <cflocation url="contact.cfm">
    </cfif>

    <cfif len(subject) LT 3>
        <cfset session.error = 'Subject can not be less than 3 characters'>
        <cflocation url="contact.cfm">
    </cfif>

    <!-- Validate message -->
    <cfif len(message) EQ 0>
        <cfset session.error = 'Message must contain some information'>
        <cflocation url="contact.cfm">
    </cfif>

    <cfif len(message) GT 1000>
        <cfset session.error = 'Message can not be more than 1000 characters'>
        <cflocation url="contact.cfm">
    </cfif>

    <cfif len(message) LT 5>
        <cfset session.error = 'Message can not be less than 5 characters'>
        <cflocation url="contact.cfm">
    </cfif>

   

</cfif>

<!-- Check if the form was submitted -->
<cfif structKeyExists(form, "submit")>

    <!-- Get form inputs -->
    <cfset name = trim(form.name)>
    <cfset email = trim(form.email)>
    <cfset subject = trim(form.subject)>
    <cfset message = trim(form.message)>

    <!-- Store form inputs in session -->
    <cfset session.name = name>
    <cfset session.email = email>
    <cfset session.subject = subject>
    <cfset session.message = message>

    <!-- Prepare email content -->
    <cfset messagemain = "
        <h2>Contact Form Enquiry</h2>
        <p>Your information was delivered successfully:</p>
        <p>Email: #email#</p>
        <p>Subject: #subject#</p>
        <p>Name: #name#</p>
        <p>Message: #message#</p>
        <a href='#base_url#/ecommerce/'>Login</a>
    ">

    <cfset subjectmain = 'Contact us issue'>
    <cfset sessionVariables = ['email', 'name', 'subject', 'message']>
    <cfset success = 'Message Sent successfully.'>
    <cfset error = 'Message could not be sent. Mailer Error: '>
    <cfset redirect_success = 'contact.cfm'>

    <!-- Call the mail_sender function to send the email -->
    <cfset mail_sender(email, subjectmain, messagemain, sessionVariables, success, error, redirect_success, redirect_success)>

    <!-- Redirect to a success page or display a success message here -->
    <cflocation url="#redirect_success#">

<cfelse>
    <!-- If the form was not submitted directly without form submission -->
    <cfset session.error = 'Error while sending your message'>
    <cflocation url="contact.cfm">
</cfif>





<?php

include 'includes/session.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = test_input($_POST['name']);
    $email = test_input($_POST['email']);
    $subject = test_input($_POST['subject']);
    $message = test_input($_POST['message']);

	$_SESSION['name'] = $name;
	$_SESSION['email'] = $email;
	$_SESSION['subject'] = $subject;
	$_SESSION['message'] = $message;

    // Validate form data
    if (empty($name) || empty($email) || empty($subject) || empty($message)) {
        $_SESSION['error'] = "Please fill in all fields.";
        header('Location: contact.php');
        exit();
    }

    //name requirement 
	if(empty($name)){
		$_SESSION['error'] = 'Name is required';
		header('location: contact.php');
		exit();
	}

	if(!preg_match("/^[a-zA-Z-' ]*$/",$name)){
		$_SESSION['error'] = 'Name must contain only letters';
		header('location: contact.php');
		exit();
	}

	if(strlen($name) > 20){
		$_SESSION['error'] = 'Name can not be more than 20 characters';
		header('location: contact.php');
		exit();
	}

	if(strlen($name) < 3 ){
		$_SESSION['error'] = 'Name can not be less than 3 characters';
		header('location: contact.php');
		exit();
	}

	//email requirement 
	if(empty($email)){
		$_SESSION['error'] = 'Email is required';
		header('location: contact.php');
		exit();
	}

	if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
		$_SESSION['error'] = 'Invalid email format';
		header('location: contact.php');
		exit();
	}

	//subject requirement 
	if(empty($subject)){
		$_SESSION['error'] = 'subject is required';
		header('location: contact.php');
		exit();
	}

	if(strlen($subject) > 50){
		$_SESSION['error'] = 'subject can not be more than 1000 characters';
		header('location: contact.php');
		exit();
	}

	if(strlen($subject) < 3 ){
		$_SESSION['error'] = 'subject can not be less than 20 characters';
		header('location: contact.php');
		exit();
	}

	//message requirement 
	if(empty($message)){
		$_SESSION['error'] = 'message must contain some information';
		header('location: contact.php');
		exit();
	}

	
	if(strlen($message) > 1000){
		$_SESSION['error'] = 'message can not be more than 1000 characters';
		header('location: contact.php');
		exit();
	}

	if(strlen($message) < 5 ){
		$_SESSION['error'] = 'message can not be less than 5 characters';
		header('location: contact.php');
		exit();
	}
    

    // Additional validation or sanitization can be performed here if needed

    // Prepare email content
    $messagemain = "
		<h2>Contact Form Enquiry</h2>
		<p>your imformation deliver successfully:</p>
		<p>Email: ".$email."</p>
		<p>Subject: ".$subject."</p>
		<p>Name: ".$name."</p>
		<p>Message: ".$message."</p>
		<a href='http://localhost/ecommerce/'>Login</a>
	";
                
    $subjectmain = 'Contact us issue';
	$sessionVariables = array('email', 'name', 'subject', 'message');
	$success = 'Message Sent successfully.';
	$error = 'Message could not be sent. Mailer Error: ';
	$redirect_success = 'contact.php';
					
	mail_sender($email, $subjectmain, 
	$messagemain, $sessionVariables, 
	$success, $error, $redirect_success,      
    $redirect_success);

     
    // $content = "From: $name\nEmail: $email\nMessage: $message";
} else {
    $_SESSION['error'] = 'error while sending your message';// Redirect back to the contact form if accessed directly without form submission
    header('Location: contact.php');
    exit;
}   



?>