<?php
    include 'includes/session.php';

    if($_SERVER["REQUEST_METHOD"] == "POST") {
        $_POST = json_decode(file_get_contents('php://input'), true);

        $email = test_input($_POST['email']);
        if(empty($email)){
            $response_data = array(
                'status' => false,
                'message' => 'Email is required'
            );
			echo json_encode($response_data);
            exit();
		}

		if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
            $response_data = array(
                'status' => false,
                'message' => 'Invalid email format'
            );
			echo json_encode($response_data);
            exit();
		}

        $conn = $pdo->open();

		$stmt = $conn->prepare("SELECT COUNT(*) AS numrows FROM subscriber_list WHERE email=:email and status=:status");
		$stmt->execute(['email'=>$email, 'status' => true]);
		$row = $stmt->fetch();

        if($row['numrows'] > 0){
            $response_data = array(
                'status' => false,
                'message' => 'Email already subscribed',
            );
			echo json_encode($response_data);
            exit();
        }

        $stmt = $conn->prepare("SELECT COUNT(*) AS numrows FROM subscriber_list WHERE email=:email and status=:status");
		$stmt->execute(['email'=>$email, 'status' => false]);
		$row = $stmt->fetch();

        if($row['numrows'] > 0){
            $conn->prepare("UPDATE subscriber_list ST  status=:status WHERE email=:email");
            $response_data = array(
                'status' => true,
                'message' => 'Email resubscribed successfully',
            );
			echo json_encode($response_data);
            exit();
        }

        $now = date("Y-m-d H:i:s");
        $stmt = $conn->prepare(
            "INSERT INTO subscriber_list (email, status, created_at, updated_at) 
            VALUES (:email, :status, :created_at, :updated_at)"
        );
        $stmt->execute([
            'email'=>$email, 
            'status'=> true, 
            'created_at'=>$now, 
            'updated_at'=>$now
        ]);

        $response_data = array(
            'status' => true,
            'message' => 'Email subscribed successfully',
        );
        echo json_encode($response_data);
        exit();

        
    }
?>