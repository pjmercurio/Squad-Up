<?php


require_once('dbconnect.php');

$email = mysqli_real_escape_string($conn, $_POST['email']);
$password = mysqli_real_escape_string($conn, $_POST['password']);

$payload = array();

$query0 = "SELECT userID, userNAME, userPASS, userSALT, userAGE, userPIC, userSQUAD FROM Squadup_User_Data WHERE userEMAIL = '$email'";

if ($result = mysqli_query($conn, $query0)) {
	if ($row = mysqli_fetch_object($result)) {
		$pass = $row->userPASS;
		$salt = $row->userSALT;

		if ($pass == generateHash($password, $salt)) {
			// Passwords match, continue login
			$payload = ["err_code"=>0, "name"=>$row->userNAME, "uid"=>$row->userID, "age"=>$row->userAGE, "pic"=>$row->userPIC, "squad"=>$row->userSQUAD];

			mysqli_query($conn, "UPDATE Squadup_User_Data SET userONLINE = 1, userLASTLOGIN = NOW() WHERE userID = '$row->userID'");
		}
		else {
			// Passwords don't match, report password mismatch error
			$payload = ["err_code"=>1];
		}
	}
	else {
		// Error with fetching object
		$payload = ["err_code"=>2];
	}
}
else {
	// Error connecting to the Database
	$payload = ["err_code"=>3];
}

function generateHash($password, $salt) {
	if ($securePass = hash("sha256", $password . $salt)) {
		return $securePass;
	}
	else {
		return false;
	}
}

echo json_encode($payload);

mysqli_close($conn);

?>