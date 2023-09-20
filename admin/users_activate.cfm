<cfscript>
    include 'includes/session.cfm';

    if (structKeyExists(form, "activate")) {
        id = form.id;

        try {
            // Define the SQL statement
            sql = "UPDATE users SET status = :status WHERE id = :id";

            // Define query parameters
            params = {
                status: { value: 1, cfsqltype: "CF_SQL_INTEGER" },
                id: { value: id, cfsqltype: "CF_SQL_INTEGER" }
            };

            // Execute the update using queryService
            queryService = new query();
            queryService.setDatasource("fashion"); //  my datasource name
            queryService.setSQL(sql);
            queryService.addParam(name="status", cfsqltype="CF_SQL_INTEGER");
            queryService.addParam(name="id", cfsqltype="CF_SQL_INTEGER");
            queryService.execute(params);

            session.success = "User activated successfully";
        } catch (any e) {
            session.error = e.message;
        }
    } else {
        session.error = "Select a user to activate first";
    }

    location("users.cfm");
</cfscript>








<?php
	include 'includes/session.php';

	if(isset($_POST['activate'])){
		$id = $_POST['id'];
		
		$conn = $pdo->open();

		try{
			$stmt = $conn->prepare("UPDATE users SET status=:status WHERE id=:id");
			$stmt->execute(['status'=>1, 'id'=>$id]);
			$_SESSION['success'] = 'User activated successfully';
		}
		catch(PDOException $e){
			$_SESSION['error'] = $e->getMessage();
		}

		$pdo->close();

	}
	else{
		$_SESSION['error'] = 'Select user to activate first';
	}

	header('location: users.php');
?>