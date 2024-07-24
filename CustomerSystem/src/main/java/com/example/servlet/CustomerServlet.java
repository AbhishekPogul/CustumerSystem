package com.example.servlet;

import com.example.dao.CustomerDAO;
import com.example.model.Customer;
import com.example.util.JWTUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/api/customers")
public class CustomerServlet extends HttpServlet {
    private final CustomerDAO customerDAO = new CustomerDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getHeader("Authorization");
        if (token == null || !JWTUtil.extractUsername(token.replace("Bearer ", "")).equals("test@sunbasedata.com")) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                Customer customer = new Customer();
                customer.setFirstName(request.getParameter("first_name"));
                customer.setLastName(request.getParameter("last_name"));
                customer.setStreet(request.getParameter("street"));
                customer.setAddress(request.getParameter("address"));
                customer.setCity(request.getParameter("city"));
                customer.setState(request.getParameter("state"));
                customer.setEmail(request.getParameter("email"));
                customer.setPhone(request.getParameter("phone"));
                customerDAO.createCustomer(customer);
                response.setStatus(HttpServletResponse.SC_CREATED);
            } else if ("update".equals(action)) {
                Customer customer = new Customer();
                customer.setId(Integer.parseInt(request.getParameter("id")));
                customer.setFirstName(request.getParameter("first_name"));
                customer.setLastName(request.getParameter("last_name"));
                customer.setStreet(request.getParameter("street"));
                customer.setAddress(request.getParameter("address"));
                customer.setCity(request.getParameter("city"));
                customer.setState(request.getParameter("state"));
                customer.setEmail(request.getParameter("email"));
                customer.setPhone(request.getParameter("phone"));
                customerDAO.updateCustomer(customer);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                customerDAO.deleteCustomer(id);
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getHeader("Authorization");
        if (token == null || !JWTUtil.extractUsername(token.replace("Bearer ", "")).equals("test@sunbasedata.com")) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("list".equals(action)) {
                int start = Integer.parseInt(request.getParameter("start"));
                int limit = Integer.parseInt(request.getParameter("limit"));
                String sortBy = request.getParameter("sort_by");
                String search = request.getParameter("search");
                PrintWriter out = response.getWriter();
                List<Customer> customers = customerDAO.getCustomers();
                // Convert customers list to JSON and write response
                response.setContentType("application/json");
                out.print("[");
                for (int i = 0; i < customers.size(); i++) {
                    Customer customer = customers.get(i);
                    out.print("{\"id\": " + customer.getId() + ", \"first_name\": \"" + customer.getFirstName() + "\", \"last_name\": \"" + customer.getLastName() + "\", \"street\": \"" + customer.getStreet() + "\", \"address\": \"" + customer.getAddress() + "\", \"city\": \"" + customer.getCity() + "\", \"state\": \"" + customer.getState() + "\", \"email\": \"" + customer.getEmail() + "\", \"phone\": \"" + customer.getPhone() + "\"}");
                    if (i < customers.size() - 1) {
                        out.print(",");
                    }
                }
                out.print("]");
                out.flush();
            } else if ("get".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Customer customer = customerDAO.getCustomerById(id);
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"id\": " + customer.getId() + ", \"first_name\": \"" + customer.getFirstName() + "\", \"last_name\": \"" + customer.getLastName() + "\", \"street\": \"" + customer.getStreet() + "\", \"address\": \"" + customer.getAddress() + "\", \"city\": \"" + customer.getCity() + "\", \"state\": \"" + customer.getState() + "\", \"email\": \"" + customer.getEmail() + "\", \"phone\": \"" + customer.getPhone() + "\"}");
                out.flush();
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
