<?php
$host = "localhost";
/*
$db_user = "mysql";
$db_pass = "^12fg7";
$db_name = "test";
*/


$db_user = "root";
$db_pass = "asdasd";
$db_name = "soya";
$timezone = "Asia/Shanghai";

$link = mysql_connect($host, $db_user, $db_pass);

mysql_select_db($db_name, $link);
mysql_query("SET names UTF8");
date_default_timezone_set($timezone);

?>