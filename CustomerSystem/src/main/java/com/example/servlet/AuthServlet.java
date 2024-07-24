package com.example.servlet;

import com.example.util.JWTUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/auth")
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String loginId = request.getParameter("login_id");
        String password = request.getParameter("password");

        // Authenticate user (dummy authentication for demo purposes)
        if ("test@sunbasedata.com".equals(loginId) && "Test@123".equals(password)) {
            String token = JWTUtil.generateToken(loginId);
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"token\": \"" + token + "\"}");
            out.flush();
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
}
