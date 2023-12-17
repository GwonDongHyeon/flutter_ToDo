<?php
include '../connection.php';

if ($connnection->connect_error) {
    die("Connection failed: " . $connnection->connect_error);
}

$id = $_POST['id'];
$memoTitle = $_POST['title'];
$memoDate = $_POST['memoDate'];
$memoContent = $_POST['content'];
$memoStartLocation = $_POST['startLocation'];
$memoEndLocation = $_POST['endLocation'];

$sqlQuery = "UPDATE user_table SET title = '$memoTitle', memoDate = '$memoDate', content = '$memoContent', startLocation = '$memoStartLocation', endLocation = '$memoEndLocation' WHERE id = $id";
$resultQuery = $connnection->query($sqlQuery);

if ($resultQuery === TRUE) {
    echo "Record updated successfully";
} else {
    echo "Error updating record: " . $connnection->error;
}

?>
