package com.aeromanage.controller;

import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.DBConnection;
import com.aeromanage.utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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

        String firstName       = request.getParameter("firstName");
        String lastName        = request.getParameter("lastName");
        String email           = request.getParameter("email");
        String phone           = request.getParameter("phone");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String adminKey        = request.getParameter("adminKey");
        String staffKey        = request.getParameter("staffKey");

        // Password match check
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
            return;
        }

        // Email already registered check
        if (userDao.findByEmail(email) != null) {
            request.setAttribute("error", "Email address is already registered.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
            return;
        }

        // ── ROLE LOGIC ───
        String emailLower = email.toLowerCase().trim();

        String role;
        String status;
        String successMessage;

        if (emailLower.endsWith("@skyline.admin.com")
                && "JavaHut-SkyLine Admin".equals(adminKey)) {
            // Admin registration
            role           = "ADMIN";
            status         = "APPROVED";
            successMessage = "Admin account created successfully! You can login now.";

        } else if (emailLower.endsWith("@skyline.staff.com")
                && "Java-Hut Skyline Staff".equals(staffKey)) {
            // Staff registration
            role           = "STAFF";
            status         = "APPROVED";
            successMessage = "Staff account created successfully! You can login now.";

        } else {
            // Normal passenger
            role           = "PASSENGER";
            status         = "PENDING";
            successMessage = "Account created successfully! Please wait for admin approval.";
        }

        // Build and save user
        User user = new User();
        user.setFullName(firstName + " " + lastName);
        user.setEmail(email.trim());
        user.setPhone(phone);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole(role);
        user.setStatus(status);

        boolean saved = userDao.save(user);

        if (saved) {
            // ====================== AUTO STAFF INSERT ======================
            if ("STAFF".equals(role)) {
                autoCreateStaffRecord(user.getUserId());
            }

            request.setAttribute("success", successMessage);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
        }
    }

    // ====================== AUTO CREATE STAFF RECORD ======================
    private void autoCreateStaffRecord(int userId) {
        String sql = """
            INSERT INTO staff (user_id, employee_code, designation, department, hire_date)
            VALUES (?, ?, ?, ?, CURDATE())
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, "EMP" + String.format("%03d", userId));   // Example: EMP007
            ps.setString(3, "Staff Member");
            ps.setString(4, "Operations");

            ps.executeUpdate();
            System.out.println("Auto-created staff record for user_id: " + userId);

        } catch (SQLException e) {
            System.err.println("Failed to create staff record (but user was created): " + e.getMessage());
        }
    }
}