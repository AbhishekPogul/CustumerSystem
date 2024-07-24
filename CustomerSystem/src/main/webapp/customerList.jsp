<!DOCTYPE html>
<html>
<head>
    <title>Customer List</title>
    <style>
        body { font-family: Arial, sans-serif; }
        form { margin: 20px 0; }
        table { width: 100%; border-collapse: collapse; }
        table, th, td { border: 1px solid black; }
        th, td { padding: 10px; text-align: left; }
        button { margin: 5px; }
    </style>
</head>
<body>
    <h1>Customer List</h1>
    <form id="searchForm">
        <label for="search">Search:</label>
        <input type="text" id="search" name="search"><br>
        <label for="searchBy">Search By:</label>
        <select id="searchBy" name="searchBy">
            <option value="first_name">First Name</option>
            <option value="city">City</option>
            <option value="email">Email</option>
            <option value="phone">Phone</option>
        </select><br>
        <button type="submit">Search</button>
    </form>
    <button id="syncButton">Sync</button>
    <table id="customerTable">
        <thead>
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <!-- Customer rows will be dynamically inserted here -->
        </tbody>
    </table>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const syncButton = document.getElementById("syncButton");
            const searchForm = document.getElementById("searchForm");
            const customerTableBody = document.getElementById("customerTable").getElementsByTagName("tbody")[0];

            // Fetch and display customers
         function fetchCustomers(search = "", searchBy = "first_name") {
                const token = localStorage.getItem("token");
                fetch("api/customers", {
                    method: "POST",
                    headers: {
                        "Authorization": "Bearer " + token,
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        action: "list",
                       
                    })
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok.');
                    }
                    return response.json();
                })
                .then(customers => {
                    customerTableBody.innerHTML = "";
                    customers.forEach(customer => {
                        const row = customerTableBody.insertRow();
                        row.insertCell(0).textContent = customer.first_name;
                        row.insertCell(1).textContent = customer.last_name;
                        row.insertCell(2).textContent = customer.email;
                        row.insertCell(3).textContent = customer.phone;
                        const actionsCell = row.insertCell(4);
                        actionsCell.innerHTML = `<button onclick="editCustomer(${customer.id})">Edit</button> <button onclick="deleteCustomer(${customer.id})">Delete</button>`;
                    });
                })
                .catch(error => {
                    console.error('There was a problem with the fetch operation:', error);
                });
            }

            // Delete customer
            function deleteCustomer(id) {
                const token = localStorage.getItem("token");
                fetch(`/api/customers?action=delete&id=${id}`, {
                    method: "POST",
                    headers: {
                        "Authorization": "Bearer " + token
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok.');
                    }
                    return fetchCustomers(); // Refresh the customer list
                })
                .catch(error => {
                    console.error('There was a problem with the fetch operation:', error);
                });
            }

            // Edit customer (Redirect to edit form or handle inline editing)
            function editCustomer(id) {
                window.location.href = `customerForm.jsp?id=${id}`;
            }

            // Sync button
            syncButton.addEventListener("click", function() {
                fetch("https://qa.sunbasedata.com/sunbase/portal/api/assignment_auth.jsp", {
                    method: "POST",
                    body: JSON.stringify({
                        login_id: "test@sunbasedata.com",
                        password: "Test@123"
                    }),
                    headers: {
                        "Content-Type": "application/json"
                    }
                })
                .then(response => response.json())
                .then(data => {
                    const syncToken = data.token;
                    return fetch("https://qa.sunbasedata.com/sunbase/portal/api/customerList", {
                        headers: {
                            "Authorization": "Bearer " + syncToken
                        }
                    });
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok.');
                    }
                    return response.json();
                })
                .then(customers => {
                    // Sync customer data with your database
                    // (In practice, you would send this data to your server to sync)
                })
                .catch(error => {
                    console.error('There was a problem with the fetch operation:', error);
                });
            });

            // Search form submit
            searchForm.addEventListener("submit", function(event) {
                event.preventDefault();
                const search = document.getElementById("search").value;
                const searchBy = document.getElementById("searchBy").value;
                fetchCustomers(search, searchBy);
            });

            // Initial fetch
            fetchCustomers();
        });
    </script>
</body>
</html>
