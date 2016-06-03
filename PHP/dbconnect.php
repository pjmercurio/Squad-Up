<?php

DEFINE ('DB_HOST', '107.180.13.125');
DEFINE ('DB_PASS', 'paulface3');
DEFINE ('DB_USER', 'paulmercurio');
DEFINE ('DB_NAME', 'Squadup');


$conn = @mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME) OR DIE("ERROR");



/*$conn = mysql_connect(DB_HOST, DB_USER, DB_PASS);
mysql_select_db($dbname, $conn);

function query($q) {
  global $conn;
  $result = mysql_query($q, $conn);
  if (!$result) {
    die("Invalid query -- $q -- " . mysql_error());
  }
  return $result;
}*/
?>
