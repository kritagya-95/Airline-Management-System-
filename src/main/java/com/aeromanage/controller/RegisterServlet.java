package com.aeromanage.controller;

import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * RegisterServlet — handles user registration for SkyLine Airlines
 *
 * URL Mapping: /register
 *
 * GET  /register → Shows the registration form (register.jsp)
 * POST /register → Validates input, hashes password, saves user with PENDING status,
 *                  and redirects with appropriate message.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show registration form
        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
            return;
        }

        // Check if email already exists
        if (userDao.findByEmail(email) != null) {
            request.setAttribute("error", "Email address is already registered.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
            return;
        }

        // Create new User object
        User user = new User();
        user.setFullName(firstName + " " + lastName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(PasswordUtil.hashPassword(password));  // Hash password before saving
        user.setRole("PASSENGER");
        user.setStatus("PENDING");

        // Save user to database
        boolean isSaved = userDao.save(user);

        if (isSaved) {
            request.setAttribute("success", "Account created successfully! Please wait for admin approval.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
        }
    }
}