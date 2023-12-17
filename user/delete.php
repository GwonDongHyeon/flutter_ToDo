<?php
include '../connection.php';

mysqli_set_charset($connnection, "utf8");

$id = $_POST['id'];

$sqlQuery = "DELETE FROM user_table WHERE id = $id";
$resultQuery = $connnection->query($sqlQuery);

if ($resultQuery === TRUE) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
?>
