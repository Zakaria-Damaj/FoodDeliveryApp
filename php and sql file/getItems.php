<?php

// Create connection
$con = mysqli_connect("localhost", "id21742170_allam", "Zakaria1Allam@", "id21742170_zakdeliveryapp");

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// Assuming you pass category_id as a parameter
$category_id = $_GET['category_id'];

// SQL query to get items based on category ID
$sql = "SELECT * FROM items WHERE cat_id = $category_id";

$result = $con->query($sql);

if ($result->num_rows > 0) {
    // Output data of each row
    $rows = array();
    while ($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
    echo json_encode($rows);
} else {
    echo "0 results";
}

$con->close();
?>
