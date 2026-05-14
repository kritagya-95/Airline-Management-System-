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
 *
 * <p>Handles POST requests submitted from the admin dashboard for approving or rejecting
 * pending passenger registrations. All requests are validated for an active admin session
 * prior to processing. On completion, the client is redirected to the dashboard
 * following the Post-Redirect-Get pattern.</p>
 *
 * <p>Mapped to: {@code /admin/users}</p>
 *
 * @see AdminDao
 * @see SessionUtil
 */
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    /**
     * Processes user management actions submitted via POST from the admin dashboard.
     *
     * <p>Validates the authenticated session and role before executing the requested
     * action. Supported actions are {@code approve} and {@code reject}, which update
     * the target user's status in the persistence layer accordingly.</p>
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} containing
     *                 {@code action} and {@code userId} parameters
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} used to
     *                 redirect the client post-execution
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) SessionUtil.getAttribute(request, "user");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action    = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.trim().isEmpty()
                || action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr.trim());
        } catch (NumberFormatException e) {
            System.err.println("[AdminUserServlet] Malformed userId parameter received: " + userIdStr);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        switch (action.trim()) {
            case "approve":
                adminDao.updateUserStatus(userId, "APPROVED");
                break;
            case "reject":
                adminDao.updateUserStatus(userId, "REJECTED");
                break;
            default:
                System.err.println("[AdminUserServlet] Unrecognised action parameter: " + action);
                break;
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}