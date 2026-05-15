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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Refined RegisterServlet following the PRG pattern and integrating BCrypt.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Parameter Extraction
        String firstName       = request.getParameter("firstName");
        String lastName        = request.getParameter("lastName");
        String email           = request.getParameter("email");
        String phone           = request.getParameter("phone");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String adminKey        = request.getParameter("adminKey");
        String staffKey        = request.getParameter("staffKey");

        // 2. Presence Validation
        if (firstName == null || firstName.trim().isEmpty()
                || lastName == null || lastName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // 3. Password Match Validation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // 4. Duplicate Email Validation
        if (userDao.findByEmail(email.trim()) != null) {
            request.setAttribute("error", "An account with this email address already exists.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // 5. Role and Status Resolution
        String emailLower = email.toLowerCase().trim();
        String role;
        String status;
        String successMessage;

        if (emailLower.endsWith("@skyline.admin.com") && "JavaHut-SkyLine Admin".equals(adminKey)) {
            role = "ADMIN";
            status = "APPROVED";
            successMessage = "Admin account created successfully.";
        } else if (emailLower.endsWith("@skyline.staff.com") && "Java-Hut Skyline Staff".equals(staffKey)) {
            role = "STAFF";
            status = "APPROVED";
            successMessage = "Staff account created successfully.";
        } else {
            role = "PASSENGER";
            status = "PENDING";
            successMessage = "Registration successful. Pending administrator approval.";
        }

        // 6. Build and Persist
        User user = new User();
        user.setFullName(firstName.trim() + " " + lastName.trim());
        user.setEmail(email.trim());
        user.setPhone(phone.trim());

        // Use PasswordUtil for BCrypt hashing
        user.setPassword(PasswordUtil.hashPassword(password));

        user.setRole(role);
        user.setStatus(status);

        boolean saved = userDao.save(user);

        if (saved) {
            // If user is Staff, wire up the staff record
            if ("STAFF".equals(role)) {
                // Fetch the ID of the user we just saved (assuming userDao.save updates the object or findByEmail)
                User savedUser = userDao.findByEmail(user.getEmail());
                userDao.saveStaffRecord(savedUser.getUserId());
            }

            // 7. PRG Pattern: REDIRECT instead of Forward
            // We pass the message as a URL parameter to be displayed on the login page
            String encodedMsg = URLEncoder.encode(successMessage, StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/login?success=" + encodedMsg);
        } else {
            request.setAttribute("error", "Server error. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}