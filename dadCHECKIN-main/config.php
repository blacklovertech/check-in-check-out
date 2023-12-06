<?php
// config.php
function getDBConnection() {

    $db_server = "localhost";
    $db_username = "root";
    $db_password = "";
    $db_database = "daddb";

    $conn = new mysqli($db_server, $db_username, $db_password, $db_database);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    return $conn;
}
?>