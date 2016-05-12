<?php
$dbhost = '107.180.13.125';
$dbuser = 'paulmercurio';
$dbpass = 'paulface3';
$dbname = 'Squadup';


$conn = mysql_connect($dbhost, $dbuser, $dbpass);
mysql_select_db($dbname, $conn);

function query($q) {
  global $conn;
  $result = mysql_query($q, $conn);
  if (!$result) {
    die("Invalid query -- $q -- " . mysql_error());
  }
  return $result;
}
?>
