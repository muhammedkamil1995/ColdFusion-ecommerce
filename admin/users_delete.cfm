<cfscript>
		include 'includes/session.cfm';

		
    if (structKeyExists(form, "delete")) {
        id = form.id;

        // Create a queryService instance and set the datasource
        queryService = new query();
        queryService.setDatasource("fashion");
        sql = "DELETE FROM users WHERE id = :id";
        queryService.setSql(sql);
        queryService.addParam(name="id", value=id, cfsqltype="cf_sql_integer");
        queryService.execute();

        if (queryService.getResult().recordCount) {
            session.success = 'User deleted successfully';
        } else {
            session.error = 'Failed to delete user';
        }
    } else {
        session.error = 'Select user to delete first';
    }
// Redirect to the users.cfm page
location("users.cfm");
</cfscript>




<cfinclude template="includes/session.cfm">





<?php
	include 'includes/session.php';

	if(isset($_POST['delete'])){
		$id = $_POST['id'];
		
		$conn = $pdo->open();

		try{
			$stmt = $conn->prepare("DELETE FROM users WHERE id=:id");
			$stmt->execute(['id'=>$id]);

			$_SESSION['success'] = 'User deleted successfully';
		}
		catch(PDOException $e){
			$_SESSION['error'] = $e->getMessage();
		}

		$pdo->close();
	}
	else{
		$_SESSION['error'] = 'Select user to delete first';
	}

	header('location: users.php');
	
?>


convrt to coldfusion and use queryService to handle 