<cfscript>
    include 'includes/session.cfm';

    if (structKeyExists(form, "add")) {
        firstname = form.firstname;
        lastname = form.lastname;
        email = form.email;
        password = form.password;
        address = form.address;
        contact = form.contact;

        try {
            // Define the SQL statement to check if the email is already taken
            emailCheckSQL = "SELECT COUNT(*) AS numrows FROM users WHERE email = :email";

            // Define query parameters for email check
            emailCheckParams = {
                email: { value: email, cfsqltype: "CF_SQL_VARCHAR" }
            };

            // Execute the email check using queryService
            emailCheckQuery = queryService.execute(
                sql = emailCheckSQL,
                params = emailCheckParams,
                datasource = "fashion"
            );
            emailCheckResult = emailCheckQuery.getResult();

            if (emailCheckResult.numrows > 0) {
                session.error = 'Email already taken';
            } else {
            
                hashedPassword = hash(password, "SHA-256");

                filename = form.photo;
                now = createDateTimeFormat("yyyy-mm-dd", now());

                if (len(filename)) {
                    // Upload the photo if provided
                    fileUploadDest = expandPath("../images/") & filename;
                    fileUploadResult = fileUpload("photo", fileUploadDest);
                }

                // Define the SQL statement to insert a new user
                insertSQL = "INSERT INTO users (email, password, firstname, lastname, address, contact_info, photo, status, created_on) 
                            VALUES (:email, :password, :firstname, :lastname, :address, :contact, :photo, :status, :created_on)";

                // Define query parameters for user insertion
                insertParams = {
                    email: { value: email, cfsqltype: "CF_SQL_VARCHAR" },
                    password: { value: hashedPassword, cfsqltype: "CF_SQL_VARCHAR" },
                    firstname: { value: firstname, cfsqltype: "CF_SQL_VARCHAR" },
                    lastname: { value: lastname, cfsqltype: "CF_SQL_VARCHAR" },
                    address: { value: address, cfsqltype: "CF_SQL_VARCHAR" },
                    contact: { value: contact, cfsqltype: "CF_SQL_VARCHAR" },
                    photo: { value: filename, cfsqltype: "CF_SQL_VARCHAR" },
                    status: { value: 1, cfsqltype: "CF_SQL_INTEGER" },
                    created_on: { value: now, cfsqltype: "CF_SQL_DATE" }
                };

                // Execute the user insertion using queryService
                queryService.execute(
                    sql = insertSQL,
                    params = insertParams,
                    datasource = "fashion" // Replace with your actual datasource name
                );

                session.success = 'User added successfully';
            }
        } catch (any e) {
            session.error = e.message;
        }
    } else {
        session.error = 'Fill up user form first';
    }

    location("users.cfm");
</cfscript>












<?php
	include 'includes/session.php';

	if(isset($_POST['add'])){
		$firstname = $_POST['firstname'];
		$lastname = $_POST['lastname'];
		$email = $_POST['email'];
		$password = $_POST['password'];
		$address = $_POST['address'];
		$contact = $_POST['contact'];

		$conn = $pdo->open();

		$stmt = $conn->prepare("SELECT *, COUNT(*) AS numrows FROM users WHERE email=:email");
		$stmt->execute(['email'=>$email]);
		$row = $stmt->fetch();

		if($row['numrows'] > 0){
			$_SESSION['error'] = 'Email already taken';
		}
		else{
			$password = password_hash($password, PASSWORD_DEFAULT);
			$filename = $_FILES['photo']['name'];
			$now = date('Y-m-d');
			if(!empty($filename)){
				move_uploaded_file($_FILES['photo']['tmp_name'], '../images/'.$filename);	
			}
			try{
				$stmt = $conn->prepare("INSERT INTO users (email, password, firstname, lastname, address, contact_info, photo, status, created_on) VALUES (:email, :password, :firstname, :lastname, :address, :contact, :photo, :status, :created_on)");
				$stmt->execute(['email'=>$email, 'password'=>$password, 'firstname'=>$firstname, 'lastname'=>$lastname, 'address'=>$address, 'contact'=>$contact, 'photo'=>$filename, 'status'=>1, 'created_on'=>$now]);
				$_SESSION['success'] = 'User added successfully';

			}
			catch(PDOException $e){
				$_SESSION['error'] = $e->getMessage();
			}
		}

		$pdo->close();
	}
	else{
		$_SESSION['error'] = 'Fill up user form first';
	}

	header('location: users.php');

?>