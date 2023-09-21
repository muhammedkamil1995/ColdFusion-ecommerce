<cfscript>
include 'includes/session.cfm';

if (structKeyExists(form, "id")) {
    id = form.id;

  
        queryService = new query();
        queryService.setDatasource("fashion");
        sql = "SELECT * FROM users WHERE id = :id";
        queryService.addParam(name="id", value=id, cfsqltype="CF_SQL_INTEGER");
        result = queryService.execute(sql=sql);

        if (result.recordCount > 0) {
            row = result[1];

            // Convert the result to JSON
            writeOutput(serializeJSON(row));
        } else {
            writeOutput('{"error": "User not found"}');
        }
    } catch (any e) {
        writeOutput('{"error": "' & e.message & '"}');
    }

</cfscript>






<?php 
	include 'includes/session.php';

	if(isset($_POST['id'])){
		$id = $_POST['id'];
		
		$conn = $pdo->open();

		$stmt = $conn->prepare("SELECT * FROM users WHERE id=:id");
		$stmt->execute(['id'=>$id]);
		$row = $stmt->fetch();
		
		$pdo->close();

		echo json_encode($row);
	}
?>