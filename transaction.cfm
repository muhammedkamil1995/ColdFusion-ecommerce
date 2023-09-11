<cfscript>
    include 'includes/session.cfm';

    id = form.id;
    

    output = {
        "list": "",
        "transaction": "",
        "date": "",
        "total": ""
    };


	 // Execute the database query
    queryService = new query();
    queryService.setDatasource("fashion"); // Set your actual datasource name
    queryService.setName("salesDetails");
    queryService.addParam(name="id", value=id, cfsqltype="CF_SQL_INTEGER");
    queryService.setSQL(sqlQuery);
	Result = queryService.execute("SELECT * FROM details LEFT JOIN products ON products.id=details.product_id LEFT JOIN sales ON sales.id=details.sales_id WHERE details.sales_id=:id");
        

    total = 0;
    list = "";
     // Loop through the query results
    for (row in queryService.getResult()) {
        output.transaction = row.pay_id;
        output.date = dateFormat(row.sales_date, "mmm dd, yyyy");
        subtotal = row.price * row.quantity;
        total += subtotal;
        list &= "<tr class='prepend_items'>
            <td>#row.name#</td>
            <td>&#36; #numberFormat(row.price, '999,999,999.99')#</td>
            <td>#row.quantity#</td>
            <td>&#36; #numberFormat(subtotal, '999,999,999.99')#</td>
        </tr>";
    }

    output.list = list;
    output.total = "<b>&#36; #numberFormat(total, '999,999,999.99')#<b>";
    application.pdo.close();
    WriteOutput(serializeJSON(output));
</cfscript>









<?php
	include 'includes/session.php';

	$id = $_POST['id'];

	$conn = $pdo->open();

	$output = array('list'=>'');

	$stmt = $conn->prepare("SELECT * FROM details LEFT JOIN products ON products.id=details.product_id LEFT JOIN sales ON sales.id=details.sales_id WHERE details.sales_id=:id");
	$stmt->execute(['id'=>$id]);

	$total = 0;
	foreach($stmt as $row){
		$output['transaction'] = $row['pay_id'];
		$output['date'] = date('M d, Y', strtotime($row['sales_date']));
		$subtotal = $row['price']*$row['quantity'];
		$total += $subtotal;
		$output['list'] .= "
			<tr class='prepend_items'>
				<td>".$row['name']."</td>
				<td>&#36; ".number_format($row['price'], 2)."</td>
				<td>".$row['quantity']."</td>
				<td>&#36; ".number_format($subtotal, 2)."</td>
			</tr>
		";
	}
	
	$output['total'] = '<b>&#36; '.number_format($total, 2).'<b>';
	$pdo->close();
	echo json_encode($output);

?>