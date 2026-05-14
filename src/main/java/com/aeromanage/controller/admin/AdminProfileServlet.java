package com.aeromanage.controller.admin;

import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet controller responsible for rendering the admin profile page.
 *
 * <p>Resolves the authenticated admin user from the current session and forwards
 * the request to the admin profile JSP view. Additionally handles consumption of
 * the {@code profileUpdateSuccess} session-scoped flash attribute, which is set
 * by {@link AdminProfileUpdateServlet} following a successful profile update.
 * The flash attribute is removed from the session immediately after being read
 * to ensure single-display behaviour.</p>
 *
 * <p>Access is restricted to authenticated users holding the {@code ADMIN} role.
 * Unauthenticated requests are redirected to the login endpoint. Authenticated
 * non-admin users are redirected to the home page.</p>
 *
 * <p>Mapped to: {@code /admin/profile}</p>
 *
 * @see AdminProfileUpdateServlet
 * @see SessionUtil
 */
@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {

    /**
     * Handles GET requests to render the admin profile view.
     *
     * <p>Validates the authenticated session and role, consumes any pending
     * flash success attribute from the session, binds the user entity to the
     * request scope, and forwards to the admin profile JSP.</p>
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

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            Boolean success = (Boolean) session.getAttribute("profileUpdateSuccess");
            if (Boolean.TRUE.equals(success)) {
                request.setAttribute("showSuccess", true);
                session.removeAttribute("profileUpdateSuccess");
            }
        }

        request.setAttribute("user", user);

        request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                .forward(request, response);
    }
}