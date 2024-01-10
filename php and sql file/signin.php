<?php
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
// Check if decoding was successful
if ($data !== null) {
    $username = $data['username'];
    $password = $data['password'];

    // Additional validation or sanitization of input data is recommended before querying the database

    $con=mysqli_connect("localhost", "id21742170_allam", "Zakaria1Allam@", "id21742170_zakdeliveryapp");
    // Check connection
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }

    try {
        // Query to fetch user from database based on username
        $sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password' LIMIT 1";
        $result = mysqli_query($con, $sql);

        if (mysqli_num_rows($result) > 0) {
            // User found
            $row = mysqli_fetch_assoc($result);
            echo json_encode(array('status' => 'Login successful', 'userId' => $row['id']));
        } else {
            echo json_encode(array('status' => 'Invalid username or password'));
        }
    } catch (Exception $e) {
        echo json_encode(array('status' => 'Error: ' . $e->getMessage()));
    }

    mysqli_close($con);
} else {
    echo "Invalid JSON data";
}
?>
