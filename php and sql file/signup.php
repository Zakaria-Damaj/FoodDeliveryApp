<?php
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
// Check if decoding was successful
if ($data !== null) {
    $username = $data['username'];
    $name = $data['name'];
    $password = $data['password'];
    $key = $data['key'];

    if ($key != "your_key" or trim($name) == "")
        die("access denied");

    $con=mysqli_connect("localhost", "id21742170_allam", "Zakaria1Allam@", "id21742170_zakdeliveryapp");
    // Check connection
    if (mysqli_connect_errno())
    {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }

    try {
        // Insert user data into the database
        $sql = "INSERT INTO users (username, name, password) VALUES ('$username', '$name', '$password')";
        mysqli_query($con, $sql);
        echo "Signup successful";  // Change the response message
    } catch (Exception $e) {
        die ($e->getMessage());
    }

    mysqli_close($con);
} else {
    echo "Invalid JSON data";
}
?>
