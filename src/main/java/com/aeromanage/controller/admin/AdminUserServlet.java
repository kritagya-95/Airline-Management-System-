package com.aeromanage.controller.admin;

import com.aeromanage.dao.AdminDao;
import com.aeromanage.dao.AdminDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * AdminUserServlet — handles admin actions on users.
 * URL: /admin/users
 * POST actions: approve, reject
 */
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        int userId = Integer.parseInt(userIdStr);

        switch (action) {
            case "approve":
                adminDao.updateUserStatus(userId, "APPROVED");
                break;
            case "reject":
                adminDao.updateUserStatus(userId, "REJECTED");
                break;
            default:
                break;
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}