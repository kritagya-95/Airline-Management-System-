package com.aeromanage.controller;

import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.PasswordUtil;
import com.aeromanage.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Direct access to login page
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 1. Sanitize Inputs
        if (email != null) email = email.trim();
        if (password != null) password = password.trim();

        // 2. Database Lookup
        User user = userDao.findByEmail(email);

        // 3. Unified Authentication Logic
        // This remains the same for the long run; logic changes only in PasswordUtil
        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {

            // Success: Initialize Session
            SessionUtil.setAttribute(request, "user", user);

            String role = user.getRole().toUpperCase();
            String contextPath = request.getContextPath();

            System.out.println("[Login] Authorized: " + email + " as " + role);

            // 4. Role-Based Routing
            switch (role) {
                case "ADMIN":
                    response.sendRedirect(contextPath + "/admin/dashboard");
                    break;
                case "STAFF":
                    response.sendRedirect(contextPath + "/staff/dashboard");
                    break;
                default:
                    response.sendRedirect(contextPath + "/profile");
                    break;
            }
        } else {
            // Failure: Return to log in with error message
            System.out.println("[Login] Refused: " + email);
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}