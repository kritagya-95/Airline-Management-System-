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
 * AdminDashboardServlet — serves the admin dashboard.
 * URL: /admin/dashboard
 * Protected by AuthFilter — only ADMIN role can access.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get logged-in admin from session
        User admin = (User) SessionUtil.getAttribute(request, "user");
        request.setAttribute("admin", admin);

        // Stats cards
        request.setAttribute("totalUsers",    adminDao.countUsers());
        request.setAttribute("totalFlights",  adminDao.countFlights());
        request.setAttribute("totalBookings", adminDao.countBookings());
        request.setAttribute("pendingUsers",  adminDao.countPendingUsers());

        // Pending user approvals list
        request.setAttribute("pendingUserList", adminDao.getPendingUsers());

        // Recent bookings
        request.setAttribute("recentBookings", adminDao.getRecentBookings(5));

        // All flights
        request.setAttribute("flightList", adminDao.getAllFlights());

        // All users
        request.setAttribute("userList", adminDao.getAllUsers());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                .forward(request, response);
    }
}