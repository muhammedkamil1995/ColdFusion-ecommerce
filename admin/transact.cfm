<?php
	// Include session configuration and functions
	include 'includes/session.php';

	// Get the sales transaction ID from the POST data
	$id = $_POST['id'];

	// Open a connection to the database
	$conn = $pdo->open();

	// Initialize an array to store output data
	$output = array('list'=>'');

	// Prepare and execute a database query to fetch transaction details
	$stmt = $conn->prepare("SELECT * FROM details LEFT JOIN products ON products.id=details.product_id LEFT JOIN sales ON sales.id=details.sales_id WHERE details.sales_id=:id");
	$stmt->execute(['id'=>$id]);

	// Initialize a variable to store the total transaction amount
	$total = 0;

	// Loop through the fetched rows
	foreach($stmt as $row){
		// Store payment ID and sales date
		$output['transaction'] = $row['pay_id'];
		$output['date'] = date('M d, Y', strtotime($row['sales_date']));

		// Calculate the subtotal for the current product
		$subtotal = $row['price'] * $row['quantity'];

		// Update the total by adding the subtotal
		$total += $subtotal;

		// Construct a table row for the product details
		$output['list'] .= "
			<tr class='prepend_items'>
				<td>".$row['name']."</td>
				<td>&#36; ".number_format($row['price'], 2)."</td>
				<td>".$row['quantity']."</td>
				<td>&#36; ".number_format($subtotal, 2)."</td>
			</tr>
		";
	}

	// Store the total transaction amount in the output array
	$output['total'] = '<b>&#36; '.number_format($total, 2).'<b>';

	// Close the database connection
	$pdo->close();

	// Convert the output array to JSON format
	echo json_encode($output);
?>