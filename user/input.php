<?php
include '../connection.php';

mysqli_set_charset($connnection, "utf8");

$memoDate = $_POST['memoDate'];
$memoTitle = $_POST['title'];
$memoContent = $_POST['content'];
$memoStartLocation = $_POST['startLocation'];
$memoEndLocation = $_POST['endLocation'];

$sqlQuery = "INSERT INTO user_table SET 
memoDate = '$memoDate', 
title = '$memoTitle',
content = '$memoContent',
startLocation = '$memoStartLocation',
endLocation = '$memoEndLocation'";

$resultQuery = $connnection->query($sqlQuery);

if ($resultQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
