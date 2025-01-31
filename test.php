<?php
$data = ["name" => "John Doe", "age" => 25];
header('Content-Type: application/json');
echo json_encode($data);
?>