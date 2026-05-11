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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        // Security Check
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("admin", user);

        // Dashboard data
        request.setAttribute("totalUsers",    adminDao.countUsers());
        request.setAttribute("totalFlights",  adminDao.countFlights());
        request.setAttribute("totalBookings", adminDao.countBookings());
        request.setAttribute("pendingUsers",  adminDao.countPendingUsers());

        request.setAttribute("pendingUserList", adminDao.getPendingUsers());
        request.setAttribute("recentBookings", adminDao.getRecentBookings(5));
        request.setAttribute("flightList", adminDao.getAllFlights());
        request.setAttribute("userList", adminDao.getAllUsers());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                .forward(request, response);
    }
}