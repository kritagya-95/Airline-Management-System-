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
 * Servlet controller responsible for rendering the administrative dashboard.
 * * <p>Access security is managed by AuthenticationFilter; this servlet
 * focuses purely on data aggregation and presentation logic.</p>
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve the authenticated user from session (guaranteed by Filter)
        User user = (User) SessionUtil.getAttribute(request, "user");
        request.setAttribute("admin", user);

        // 2. Data Aggregation for Statistics
        request.setAttribute("totalUsers",    adminDao.countUsers());
        request.setAttribute("totalFlights",  adminDao.countFlights());
        request.setAttribute("totalBookings", adminDao.countBookings());
        request.setAttribute("pendingUsers",  adminDao.countPendingUsers());

        // 3. Operational Data Lists
        request.setAttribute("pendingUserList", adminDao.getPendingUsers());
        request.setAttribute("recentBookings",  adminDao.getRecentBookings(5));
        request.setAttribute("flightList",      adminDao.getAllFlights());
        request.setAttribute("userList",        adminDao.getAllUsers());

        // 4. Forward to the view layer
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                .forward(request, response);
    }
}