<?php
// Database connection parameters
$host = 'db4free.net';
$port = 3306;
$username = 'blacklovertech';
$password = 'Maha0508@#$';
$dbname = 'checkinout';

// Create a database connection
$conn = new mysqli($host, $username, $password, $dbname, $port);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Process the scanned data and action
    $scannedData = $_POST['scannedData'];

    // Check if the intern with the given barcode exists
    $stmt = $conn->prepare("SELECT * FROM interns WHERE barcode = ?");
    $stmt->bind_param('s', $scannedData);
    $stmt->execute();
    $result = $stmt->get_result();
    $intern = $result->fetch_assoc();

    if ($intern) {
        // Intern found, determine entry type
        $latestLog = getLatestLog($conn, $intern['id']);

        // Determine action based on the latest log entry
        $action = ($latestLog && $latestLog['exit_time'] === null) ? 'checkout' : 'checkin';

        // Log the entry
        $entryTime = date('Y-m-d H:i:s');
        logEntry($conn, $intern['id'], $action, $entryTime);

        // Display intern's name and additional information
        $internName = $intern['name'];
        $message = "Entry logged successfully. Intern: $internName, Action: $action";

        if ($action === 'checkout' && $latestLog) {
            // Calculate total time spent if checking out
            $totalTimeSpent = calculateTotalTimeSpent($latestLog['entry_time'], $entryTime);
            $message .= ", Total Time Spent: $totalTimeSpent";
        }

        // You can add additional logic or feedback here if needed
        echo $message;
    } else {
        // Intern not found, handle accordingly
        echo "Error: Intern not found.";
    }
}

function calculateTotalTimeSpent($entryTime, $exitTime) {
    // Calculate the total time spent between entry and exit
    $entryTimestamp = strtotime($entryTime);
    $exitTimestamp = strtotime($exitTime);

    $totalSeconds = $exitTimestamp - $entryTimestamp;
    $hours = floor($totalSeconds / 3600);
    $minutes = floor(($totalSeconds % 3600) / 60);
    $seconds = $totalSeconds % 60;

    return sprintf('%02d:%02d:%02d', $hours, $minutes, $seconds);
}

function getLatestLog($conn, $internId) {
    // Get the latest log entry for the intern
    $stmt = $conn->prepare("SELECT * FROM entry_log WHERE intern_id = ? ORDER BY entry_time DESC LIMIT 1");
    $stmt->bind_param('i', $internId);
    $stmt->execute();
    $result = $stmt->get_result();
    return $result->fetch_assoc();
}

function logEntry($conn, $internId, $action, $entryTime) {
    // Log the entry
    if ($action === 'checkin') {
        $stmt = $conn->prepare("INSERT INTO entry_log (intern_id, entry_time) VALUES (?, ?)");
    } elseif ($action === 'checkout') {
        $stmt = $conn->prepare("UPDATE entry_log SET exit_time = ? WHERE intern_id = ? AND exit_time IS NULL");
    }

    $stmt->bind_param('si', $entryTime, $internId);
    $stmt->execute();
}

// Close the database connection
$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check-In/Check-Out Page</title>
    <!-- Materialize CSS and JavaScript CDN links -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        form {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        label {
            display: block;
            margin-bottom: 10px;
        }

        input, select, button {
            margin-bottom: 20px;
            padding: 10px;
            width: 100%;
            box-sizing: border-box;
        }

        button {
            background-color: #4caf50;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }

        #result {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form action="index.php" method="post">
        <h1>Check-In/Check-Out Page</h1>

        <!-- Input field for scanned data -->
        <div class="input-field">
            <label for="scannedData">Scanned Data:</label>
            <input type="text" name="scannedData" id="scannedData" placeholder="Scan Barcode" autofocus required>
        </div>

        <!-- Hidden field for action -->
        <input type="hidden" name="action" id="action">

        <!-- Display area for the result -->
        <div id="result"></div>

        <!-- Button to process the scanned data -->
        <button class="btn waves-effect waves-light" type="button" onclick="processData()">Process Data
            <i class="material-icons right">send</i>
        </button>
    </form>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            M.AutoInit();
        });

        function processData() {
            // Set the action based on the latest log entry
            document.getElementById('action').value = determineAction();
            
            // Submit the form
            document.forms[0].submit();
        }

        function determineAction() {
            // Determine action based on the latest log entry
            var latestLogExitTime = <?php echo json_encode($latestLog['exit_time']); ?>;
            return (latestLogExitTime === null) ? 'checkout' : 'checkin';
        }
    </script>
</body>
</html>
