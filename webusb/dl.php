<?php 

$id = $_GET["id"];
$fname = $_GET["name"];

header( 'Location: ./'.$id.'/'.$fname ) ;

//echo '<META HTTP-EQUIV="Refresh" CONTENT="0; URL="http://137.189.133.71/zhoujj/learnPHP/sqlite3/'.$id.'/'.$fname.'">';

?>
