package com.aeromanage.controller.admin;

import com.aeromanage.dao.AdminDao;
import com.aeromanage.dao.AdminDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet controller responsible for processing administrative actions on user accounts.
 * * <p>Access security is managed by AuthenticationFilter. This servlet handles
 * the logic for approving or rejecting user registrations from the admin dashboard.</p>
 */
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Authentication/Authorization is guaranteed by AuthenticationFilter
        // No need for 'currentUser == null' or role checks here.

        String action    = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        // 2. Input Validation
        if (userIdStr == null || userIdStr.trim().isEmpty()
                || action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr.trim());
        } catch (NumberFormatException e) {
            // Log malformed ID but don't crash
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // 3. Logic Execution
        // Using toLowerCase() makes the action check a bit more robust
        switch (action.trim().toLowerCase()) {
            case "approve":
                adminDao.updateUserStatus(userId, "APPROVED");
                break;
            case "reject":
                adminDao.updateUserStatus(userId, "REJECTED");
                break;
            default:
                // Log unrecognised action if necessary
                break;
        }

        // 4. PRG Pattern: Redirect back to the dashboard to refresh the lists
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}