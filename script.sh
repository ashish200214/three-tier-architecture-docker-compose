#!/bin/bash

PROJECT="./"
ASSETS="$PROJECT/assets"
CSS="$PROJECT/css"
JS="$PROJECT/js"
PHP="$PROJECT/php"

echo "Creating project structure..."

mkdir -p $PROJECT
mkdir -p $ASSETS
mkdir -p $CSS
mkdir -p $JS
mkdir -p $PHP

#######################################
# ---------- CSS FILE ---------------
#######################################
cat << 'EOF' > $CSS/style.css
body {
    background: #f3f5f7;
    font-family: Arial, sans-serif;
    display: flex;
    justify-content: center;
    padding-top: 40px;
}

.card {
    width: 400px;
    background: white;
    padding: 25px;
    border-radius: 14px;
    box-shadow: 0 3px 12px rgba(0,0,0,0.1);
}

.card h2 {
    text-align: center;
    margin-bottom: 25px;
}

input, button {
    width: 100%;
    padding: 12px;
    margin-top: 12px;
    border-radius: 8px;
    border: 1px solid #ccc;
}

button {
    background: #007bff;
    color: white;
    border: none;
    font-weight: bold;
    cursor: pointer;
}

button:hover {
    background: #0056b3;
}
EOF

#######################################
# ---------- JAVASCRIPT -------------
#######################################
cat << 'EOF' > $JS/validate.js
function validateForm() {
    let name = document.forms["regForm"]["fullname"].value;
    let email = document.forms["regForm"]["email"].value;
    let pass = document.forms["regForm"]["password"].value;

    if (name == "" || email == "" || pass == "") {
        alert("All fields are required!");
        return false;
    }
    return true;
}
EOF

#######################################
# ---------- INDEX (REGISTER) --------
#######################################
cat << 'EOF' > $PROJECT/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Registration</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/validate.js"></script>
</head>
<body>
<div class="card">
    <h2>Create Account</h2>
    <form name="regForm" action="php/submit.php" method="POST" onsubmit="return validateForm()">
        <input type="text" name="fullname" placeholder="Enter Full Name">
        <input type="email" name="email" placeholder="Enter Email">
        <input type="password" name="password" placeholder="Enter Password">
        <button type="submit">Register</button>
    </form>
    <p style="text-align:center;margin-top:10px;">
        <a href="login.html">Already have an account? Login</a>
    </p>
</div>
</body>
</html>
EOF

#######################################
# ---------- LOGIN PAGE --------------
#######################################
cat << 'EOF' > $PROJECT/login.html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="card">
    <h2>Login</h2>
    <form action="php/login.php" method="POST">
        <input type="email" name="email" placeholder="Enter Email">
        <input type="password" name="password" placeholder="Enter Password">
        <button type="submit">Login</button>
    </form>
</div>
</body>
</html>
EOF

#######################################
# ---------- CONFIG FILE -------------
#######################################
cat << 'EOF' > $PHP/config.php
<?php
$host = "db";
$user = "root";
$pass = "root";
$db   = "mydb";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
} catch (Exception $e) {
    die("DB Connection failed: " . $e->getMessage());
}
?>
EOF

#######################################
# ---------- SUBMIT (REGISTER) -------
#######################################
cat << 'EOF' > $PHP/submit.php
<?php
include "config.php";

$name = $_POST["fullname"];
$email = $_POST["email"];
$pass = $_POST["password"];

$stmt = $conn->prepare("INSERT INTO users(fullname, email, password) VALUES (?, ?, ?)");
$stmt->execute([$name, $email, $pass]);

echo "<h2>Registration Successful!</h2>";
echo "<a href='../login.html'>Login Now</a>";
?>
EOF

#######################################
# ---------- LOGIN HANDLER -----------
#######################################
cat << 'EOF' > $PHP/login.php
<?php
include "config.php";

$email = $_POST["email"];
$pass = $_POST["password"];

$stmt = $conn->prepare("SELECT * FROM users WHERE email=? AND password=?");
$stmt->execute([$email, $pass]);

$user = $stmt->fetch();

if ($user) {
    echo "<h1>Welcome, {$user['fullname']}</h1>";
    echo "<p>Email: {$user['email']}</p>";
} else {
    echo "<h2>Invalid credentials!</h2>";
    echo "<a href='../login.html'>Try Again</a>";
}
?>
EOF

#######################################
# ---------- MYSQL TABLE -------------
#######################################
echo "Run this inside MySQL container:"
echo ""
echo "    CREATE TABLE users ("
echo "      id INT AUTO_INCREMENT PRIMARY KEY,"
echo "      fullname VARCHAR(100),"
echo "      email VARCHAR(100),"
echo "      password VARCHAR(100)"
echo "    );"
echo ""

echo "Project Created Successfully 🎉"
