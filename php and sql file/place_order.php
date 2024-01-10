<?php


// Create connection
$con = mysqli_connect("localhost", "id21742170_allam", "Zakaria1Allam@", "id21742170_zakdeliveryapp");

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// Read JSON data sent by Flutter app
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, true);

// Extract data
$totalPrice = $input['totalPrice'];
$items = $input['items'];

// Insert new order
$insertOrderQuery = "INSERT INTO orders (total_price) VALUES ($totalPrice)";
mysqli_query($con, $insertOrderQuery);
$orderID = mysqli_insert_id($con);

// Insert order details
foreach ($items as $item) {
    $itemName = $item['item_name'];
    $itemPrice = $item['item_price'];
    $quantity = $item['quantity'];

    $insertOrderDetailsQuery = "INSERT INTO orderdetails (order_id, item_name, item_price, quantity) 
                                VALUES ($orderID, '$itemName', $itemPrice, $quantity)";
    mysqli_query($con, $insertOrderDetailsQuery);
}

// Close the database connection
mysqli_close($con);

?>
