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

/**
 * LoginServlet — handles user login for SkyLine Airlines
 *
 * URL Mapping: /login
 *
 * GET  /login  → Shows the login form (login.jsp)
 * POST /login  → Processes login credentials, verifies password,
 *                stores user in session, and redirects by role.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, skip the login page
        User existing = (User) SessionUtil.getAttribute(request, "user");
        if (existing != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic null/empty check
        if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
            return;
        }

        // Find user by email
        User user = userDao.findByEmail(email.trim());

        if (user == null) {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
            return;
        }

        // Check account status before verifying password
        if ("PENDING".equals(user.getStatus())) {
            request.setAttribute("error", "Your account is pending admin approval. Please wait.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
            return;
        }

        if ("REJECTED".equals(user.getStatus())) {
            request.setAttribute("error", "Your account has been rejected. Please contact support.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
            return;
        }

        // Verify password using BCrypt
        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
            return;
        }

        // Store user in session
        SessionUtil.setAttribute(request, "user", user);

        // Redirect based on role
        switch (user.getRole()) {
            case "ADMIN":
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
            case "STAFF":
                response.sendRedirect(request.getContextPath() + "/staff/dashboard");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}