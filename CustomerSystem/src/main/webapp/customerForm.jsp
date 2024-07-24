<!DOCTYPE html>
<html>
<head>
    <title>Customer Form</title>
    <style>
        body { font-family: Arial, sans-serif; }
        form { margin: 20px 0; }
        label { display: block; margin: 5px 0; }
        input, button { margin: 5px 0; }
    </style>
</head>
<body>
    <h1>Customer Form</h1>
    <form id="customerForm">
        <input type="hidden" id="id" name="id">
        <label for="first_name">First Name:</label>
        <input type="text" id="first_name" name="first_name" required><br>
        <label for="last_name">Last Name:</label>
        <input type="text" id="last_name" name="last_name" required><br>
        <label for="street">Street:</label>
        <input type="text" id="street" name="street"><br>
        <label for="address">Address:</label>
        <input type="text" id="address" name="address"><br>
        <label for="city">City:</label>
        <input type="text" id="city" name="city"><br>
        <label for="state">State:</label>
        <input type="text" id="state" name="state"><br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br>
        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone"><br>
        <button type="submit">Save</button>
    </form>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const token = localStorage.getItem("token");
            const form = document.getElementById("customerForm");
            const id = new URLSearchParams(window.location.search).get("id");

            if (id) {
                fetch(`api/customers?action=get&id=${id}`, {
                    headers: {
                        "Authorization": "Bearer " + token
                    }
                })
                .then(response => response.json())
                .then(customer => {
                    document.getElementById("id").value = customer.id;
                    document.getElementById("first_name").value = customer.first_name;
                    document.getElementById("last_name").value = customer.last_name;
                    document.getElementById("street").value = customer.street;
                    document.getElementById("address").value = customer.address;
                    document.getElementById("city").value = customer.city;
                    document.getElementById("state").value = customer.state;
                    document.getElementById("email").value = customer.email;
                    document.getElementById("phone").value = customer.phone;
                });
            }

            form.addEventListener("submit", function(event) {
                event.preventDefault();
                const action = id ? "update" : "create";
                fetch("api/customers", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded",
                        "Authorization": "Bearer " + token
                    },
                    body: new URLSearchParams(new FormData(form)).toString() + "&action=" + action
                })
                .then(() => window.location.href = "customerList.jsp");
            });
        });
    </script>
</body>
</html>
