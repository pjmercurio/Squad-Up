<?php


require_once('dbconnect.php');

$uid = mysqli_real_escape_string($conn, $_POST['uid']);
$online = mysqli_real_escape_string($conn, $_POST['online']);

$payload = ["err_code"=>0];

if (!mysqli_query($conn, "UPDATE Squadup_User_Data SET userONLINE = $online WHERE userID = '$uid'")) {
	$payload["err_code"] = 3;
}

echo json_encode($payload);

mysqli_close($conn);

?>