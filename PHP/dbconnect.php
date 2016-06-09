<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

//DEFINE ('DB_HOST', '107.180.13.125');
DEFINE ('DB_HOST', 'localhost');
DEFINE ('DB_PASS', 'time2squadup');
DEFINE ('DB_USER', 'squadup_user');
DEFINE ('DB_NAME', 'Squadup');

$conn = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if (!$conn) {
	echo json_encode(["err_code"=>-1]);
}

?>
