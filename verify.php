<?php
	include 'includes/session.php';
	$conn = $pdo->open();

	if(isset($_POST['login'])){

		$email = test_input($_POST['email']);
		$password = test_input($_POST['password']);
		
		
		if(empty($email)){
			$_SESSION['error'] = 'Email is required';
			header('location: login.php');
			exit();
		}

		if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
			$_SESSION['error'] = 'Invalid email format';
			header('location: login.php');
			exit();
		}

		if(empty($password)){
			$_SESSION['error'] = 'Password is required';
			header('location: login.php');
			exit();
		}

		try{

			$stmt = $conn->prepare("SELECT *, COUNT(*) AS numrows FROM users WHERE email = :email");
			$stmt->execute(['email'=>$email]);
			$row = $stmt->fetch();
			if($row['numrows'] > 0){
				if($row['status']){
					if(password_verify($password, $row['password'])){
						if($row['type']){
							$_SESSION['admin'] = $row['id'];
						} else {
							$_SESSION['user'] = $row['id'];
						}
					}
					else{
						$_SESSION['error'] = 'Incorrect Password';
					}
				}
				else{
					$_SESSION['error'] = 'Account not activated.';
				}
			} else {
				$_SESSION['error'] = 'Email not found';
			}
		}
		catch(PDOException $e){
			echo "There is some problem in connection: " . $e->getMessage();
		}

	} else {
		$_SESSION['error'] = 'Input login credentails first';
	}

	$pdo->close();

	header('location: login.php');

?>