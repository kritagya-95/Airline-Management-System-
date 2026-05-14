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
 *
 * <p>Aggregates operational data from the persistence layer including user statistics,
 * flight inventory, recent booking records, and pending registration approvals.
 * All aggregated data is bound to the request scope and forwarded to the dashboard
 * JSP view for rendering.</p>
 *
 * <p>Access is restricted to authenticated users holding the {@code ADMIN} role.
 * Unauthenticated or unauthorized requests are redirected to the login endpoint.</p>
 *
 * <p>Mapped to: {@code /admin/dashboard}</p>
 *
 * @see AdminDao
 * @see SessionUtil
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    /**
     * Handles GET requests to render the admin dashboard view.
     *
     * <p>Verifies the presence of an authenticated admin session before
     * fetching aggregated statistics and list data from the persistence layer.
     * All resolved data is set as request attributes and forwarded to the
     * dashboard JSP for presentation.</p>
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} from the client
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} to the client
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("admin", user);

        request.setAttribute("totalUsers",    adminDao.countUsers());
        request.setAttribute("totalFlights",  adminDao.countFlights());
        request.setAttribute("totalBookings", adminDao.countBookings());
        request.setAttribute("pendingUsers",  adminDao.countPendingUsers());

        request.setAttribute("pendingUserList", adminDao.getPendingUsers());
        request.setAttribute("recentBookings",  adminDao.getRecentBookings(5));
        request.setAttribute("flightList",      adminDao.getAllFlights());
        request.setAttribute("userList",        adminDao.getAllUsers());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                .forward(request, response);
    }
}