<?php

require_once('dbconnect.php');

$email = $_POST['email'];
$pass = $_POST['password'];

$query = "SELECT userNAME, userPIC, userSQUAD FROM Sqadup_User_Data WHERE userEMAIL = $email";



?>
