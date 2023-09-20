<cfscript>
    include 'includes/session.cfm';

    if (structKeyExists(form, "upload")) {
        id = form.id;
        filename = form.photo.name;

        // Check if a file was uploaded
        if (len(filename) > 0) {
            destinationFolder = expandPath("../images/");
            fileUpload(destinationFolder, "photo", "auto");
            fullFilePath = destinationFolder & filename;
        } else {
            fullFilePath = ""; // No file uploaded
        }

        try {
            queryService = new QueryExecute();
            sql = "UPDATE users SET photo = :photo WHERE id = :id";

            // Define the SQL parameters
            params = {
                id: { value: id, cfsqltype: "cf_sql_integer" },
                photo: { value: filename, cfsqltype: "cf_sql_varchar" }
            };

            result = queryService.execute(sql, params);

            if (result.recordCount > 0) {
                session.success = 'User photo updated successfully';
            } else {
                session.error = 'Failed to update user photo';
            }
        } catch (any e) {
            // Handle exceptions
            session.error = "An error occurred: " & e.getMessage();
        }
    } else {
        session.error = 'Select user to update photo first';
    }

    // Redirect to the users.php page
    location("users.cfm");
</cfscript>




<?php
	include 'includes/session.php';

	if(isset($_POST['upload'])){
		$id = $_POST['id'];
		$filename = $_FILES['photo']['name'];
		if(!empty($filename)){
			move_uploaded_file($_FILES['photo']['tmp_name'], '../images/'.$filename);	
		}
		
		$conn = $pdo->open();

		try{
			$stmt = $conn->prepare("UPDATE users SET photo=:photo WHERE id=:id");
			$stmt->execute(['photo'=>$filename, 'id'=>$id]);
			$_SESSION['success'] = 'User photo updated successfully';
		}
		catch(PDOException $e){
			$_SESSION['error'] = $e->getMessage();
		}

		$pdo->close();

	}
	else{
		$_SESSION['error'] = 'Select user to update photo first';
	}

	header('location: users.php');
?>