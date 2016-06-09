<?php

require_once('dbconnect.php');
require_once('responsecodes.php');

$name = $_POST['username'];
$email = $_POST['email'];
$age = $_POST['age'];
$pass = $_POST['password'];
$payload = array();


if ($theHash = generateHash($pass)) {
	$securePass = $theHash[0];
	$salt = $theHash[1];
}


$query0 = "SELECT userID FROM Squadup_User_Data WHERE userEMAIL = '$email'";

if ($result0 = mysqli_query($conn, $query0)) {
	if ($result0->num_rows != null) {
		// Email exists already, so tell user this as err no 1
		$payload = ["err"=>1];
	}
	else {
		$query1 = "INSERT INTO Squadup_User_Data (userNAME, userEMAIL, userPASS, userSALT, userAGE, userCREATED) VALUES ('$name', '$email', '$securePass', '$salt', '$age', NOW())";
		if (mysqli_query($conn, $query1)) {
			// Insertion of new user info was successful
			$payload = ["err"=>0];
		}
		else {
			// There was an error with the insertion, report as error no 2
			$payload = ["err"=>2];
		}
	}
		
}

function generateHash($password) {
	$salt = openssl_random_pseudo_bytes(16, $cstrong);
	if ($securePass = hash("sha256", $password . $salt)) {
		return array($securePass, $salt);
	}
	else {
		return false;
	}
}

echo json_encode($payload);

mysqli_close($conn);


?>
