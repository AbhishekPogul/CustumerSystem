<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; }
        form { margin: 20px 0; }
        label { display: block; margin: 5px 0; }
        input, button { margin: 5px 0; }
    </style>
</head>
<body>
    <h1>Login</h1>
    <form id="loginForm">
        <label for="login_id">Login ID:</label>
        <input type="text" id="login_id" name="login_id" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <button type="submit">Login</button>
    </form>
    <script>
        document.getElementById("loginForm").addEventListener("submit", function(event) {
            event.preventDefault();
            fetch("api/auth", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams(new FormData(this)).toString()
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok.');
                }
                return response.json();
            })
            .then(data => {
                if (data.token) {
                    localStorage.setItem("token", data.token);
                    window.location.href = "customerList.jsp";
                } else {
                    alert("Invalid credentials");
                }
            })
            .catch(error => {
                console.error('There was a problem with the fetch operation:', error);
            });
        });
    </script>
</body>
</html>
