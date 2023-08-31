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