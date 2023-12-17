<?php
include '../connection.php';

mysqli_set_charset($connnection, "utf8");

$sqlQuery = "SELECT CAST(id AS UNSIGNED) AS id, memoDate, title, content, startLocation, endLocation FROM user_table";
$resultQuery = $connnection->query($sqlQuery);

$data = array();
if ($resultQuery->num_rows > 0) {
    while ($row = $resultQuery->fetch_assoc()) {
        $row['id'] = (int) $row['id'];
        $data[] = $row;
    }
}

header('Content-Type: application/json');
echo json_encode($data);

?>
