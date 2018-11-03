<?php 

//phpinfo();

$conn = oci_connect('app_roa', 'APP_ROA', 'wxp/XE');

if (!$conn) {
    $e = oci_error();
    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
}

$sqltext = $_GET["sql"];

$sql = oci_parse($conn, $sqltext);

oci_execute($sql);

$rows = array();
while($r = oci_fetch_assoc($sql)) {
	$rows[] = $r;
}
$result_arr = array("data" => $rows);

$result =(json_encode($result_arr));

echo $result;


?>