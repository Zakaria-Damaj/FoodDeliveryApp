<?php

// Connect to the database
$con = mysqli_connect("localhost", "id21742170_allam", "Zakaria1Allam@", "id21742170_zakdeliveryapp");

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// Fetch categories from the database
$query = "SELECT * FROM category";
if ($result = mysqli_query($con,$query))
  {
   $emparray = array();
   while($row =mysqli_fetch_assoc($result))
       $emparray[] = $row;

  echo(json_encode($emparray));
  // Free result set
  mysqli_free_result($result);
  mysqli_close($con);
}

?> 	

