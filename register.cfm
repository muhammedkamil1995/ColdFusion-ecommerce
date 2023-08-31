<?php
	include 'includes/session.php';

	require_once  __DIR__ .'/vendor/autoload.php';

	if(isset($_POST['signup'])) {

		$protocol = stripos($_SERVER['SERVER_PROTOCOL'], 'https') === 0 ? 'https://' : 'http://';
		$host = $_SERVER['HTTP_HOST'];

		$base_url = $protocol . $host;


		$firstname = test_input($_POST['firstname']);
		$lastname = test_input($_POST['lastname']);
		$email = test_input($_POST['email']);
		$password = test_input($_POST['password']);
		$repassword = test_input($_POST['repassword']);

		$_SESSION['firstname'] = $firstname;
		$_SESSION['lastname'] = $lastname;
		$_SESSION['email'] = $email;
		
		 //firstname requirement 
		if(empty($firstname)){
			$_SESSION['error'] = 'First Name is required';
			header('location: signup.php');
			exit();
		}

		if(!preg_match("/^[a-zA-Z']*$/",$firstname)){
			$_SESSION['error'] = 'First Name must contain only letters';
			header('location: signup.php');
			exit();
		}

		if(strlen($firstname) > 20){
			$_SESSION['error'] = 'First Name can not be more than 20 characters';
			header('location: signup.php');
			exit();
		}

		if(strlen($firstname) < 3 ){
			$_SESSION['error'] = 'First Name can not be less than 3 characters';
			header('location: signup.php');
			exit();
		}

		//last Name requirement 
		if(empty($lastname)){
			$_SESSION['error'] = 'Last Name is required';
			header('location: signup.php');
			exit();
		}


		if(!preg_match("/^[a-zA-Z']*$/",$lastname)){
			$_SESSION['error'] = 'Last Name must contain only letters';
			header('location: signup.php');
			exit();
		}

		
		if(strlen($lastname) > 20){
			$_SESSION['error'] = 'Last Name can not be more than 20 characters';
			header('location: signup.php');
			exit();
		}

		if(strlen($lastname) < 3 ){
			$_SESSION['error'] = 'Last Name can not be less than 3 characters';
			header('location: signup.php');
			exit();
		}

		//email requirement 
		if(empty($email)){
			$_SESSION['error'] = 'Email is required';
			header('location: signup.php');
			exit();
		}

		if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
			$_SESSION['error'] = 'Invalid email format';
			header('location: signup.php');
			exit();
		}

		//password requirement 
		if(!preg_match('/^(?=.*\d)(?=.*[A-Za-z])[0-9A-Za-z!@#$%]{8,24}$/', $password)) {
			$_SESSION['error'] = 'the password does not meet the requirements!';
			header('location: signup.php');
			exit();
		}

		$secret = '6LdbMx4nAAAAAOi4zVP4MVz1CdZSj2WhDQD3HXiA';

		if(!isset($_SESSION['captcha'])){
			$recaptcha = new \ReCaptcha\ReCaptcha( $secret );
			$resp = $recaptcha->setExpectedHostname($_SERVER['SERVER_NAME'])
                      ->verify($_POST['g-recaptcha-response'], $_SERVER['REMOTE_ADDR']);

			if (!$resp->isSuccess()){
		  		$_SESSION['error'] = 'Please answer recaptcha correctly';
		  		header('location: signup.php');
		  		exit();
		  	}	
		  	else{
		  		$_SESSION['captcha'] = time() + (10*60);
		  	}

		}

		if($password != $repassword){
			$_SESSION['error'] = 'Passwords did not match';
			header('location: signup.php');
			exit();
		} else {
			$conn = $pdo->open();

			$stmt = $conn->prepare("SELECT COUNT(*) AS numrows FROM users WHERE email=:email");
			$stmt->execute(['email'=>$email]);
			$row = $stmt->fetch();
			if($row['numrows'] > 0){
				$_SESSION['error'] = 'Email already taken';
				header('location: signup.php');
				exit();
			} else {
				$now = date('Y-m-d');
				$password = password_hash($password, PASSWORD_DEFAULT);

				//generate code
				$set='123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
				$code=substr(str_shuffle($set), 0, 12);

				try{
					$stmt = $conn->prepare(
						"INSERT INTO users (email, password, firstname, lastname, activate_code, created_on) 
						VALUES (:email, :password, :firstname, :lastname, :code, :now)"
					);
					$stmt->execute([
						'email'=>$email, 
						'password'=>$password, 
						'firstname'=>$firstname, 
						'lastname'=>$lastname, 
						'code'=>$code, 
						'now'=>$now
					]);
					$userid = $conn->lastInsertId();

					$message = "
						<h2>Thank you for Registering.</h2>
						<p>Your Account:</p>
						<p>Email: ".$email."</p>
						<p>Please click the link below to activate your account.</p>
						<a href='$base_url/ecommerce/activate.php?code=".$code."&user=".$userid."'>Activate Account</a>
					";

					//Load phpmailer
					$subject = 'Welcome to Afric Comm';
					$sessionVariables = array('firstname', 'lastname', 'email');
					$success = 'Account created. Check your email to activate.';
					$error = 'Message could not be sent. Mailer Error: ';
					$redirect_success = 'signup.php';
					
					mail_sender($email, $subject, 
					$message, $sessionVariables, 
					$success, $error, $redirect_success,
					$redirect_success);

				}
				catch(PDOException $e){
					$_SESSION['error'] = $e->getMessage();
					header('location: register.php');
				}

				$pdo->close();

			}

		}

	}



	

	if(isset($_POST['activation'])) {
		$email = test_input($_POST['email']);
		$_SESSION['email'] = $email;

		if(empty($email)){
			$_SESSION['error'] = 'Email is required';
			header('location: email_activation.php');
			exit();
		}

		if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
			$_SESSION['error'] = 'Invalid email format';
			header('location: email_activation.php');
			exit();
		}

		$conn = $pdo->open();

		$stmt = $conn->prepare("SELECT id, COUNT(*) AS numrows FROM users WHERE email=:email");
		$stmt->execute(['email'=>$email]);
		$row = $stmt->fetch();

		if($row['numrows'] > 0){
			$set='123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
			$code=substr(str_shuffle($set), 0, 12);

			try{
				$stmt = $conn->prepare(
					"UPDATE users set activate_code = :code WHERE email = :email"
				);
				$stmt->execute([
					'email'=>$email, 
					'code'=>$code
				]);
				$userid = $row['id'];

				$message = "
					<h2>Activate Your Account.</h2>
					<p>Your Account:</p>
					<p>Email: ".$email."</p>
					<p>Please click the link below to activate your account.</p>
					<a href='http://localhost/ecommerce/activate.php?code=".$code."&user=".$userid."'>Activate Account</a>
				";

				$subject = 'Activate Your Account on Afric Comm';
				$sessionVariables = array('email');
				$success = 'Check your email to activate.';
				$error = 'Message could not be sent. Mailer Error: ';
				$redirect_success = 'email_activation.php';
					
				mail_sender($email, $subject, 
				$message, $sessionVariables, 
				$success, $error, $redirect_success,
				$redirect_success);


			} catch(PDOException $e){ 
				$_SESSION['error'] = $e->getMessage();
				header('location: email_activation.php');
			}

			$pdo->close();
		} else {
			$_SESSION['error'] = 'email is either wrong or invalid ';
			header('location: email_activation.php');
		}
		
	}

	?>