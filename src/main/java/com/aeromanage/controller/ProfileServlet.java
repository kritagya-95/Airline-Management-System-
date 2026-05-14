package com.aeromanage.controller;

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
 * Servlet controller responsible for rendering the passenger profile page.
 *
 * <p>Resolves the authenticated user from the current session and forwards the
 * request to the passenger profile JSP view. Handles consumption of the
 * {@code profileUpdateSuccess} session-scoped flash attribute set by
 * {@link ProfileUpdateServlet} following a successful profile update, removing
 * it immediately after resolution to enforce single-display behaviour.</p>
 *
 * <p>Access is restricted to authenticated users holding the {@code PASSENGER} role.
 * Unauthenticated requests are redirected to the login endpoint. Admin and staff
 * users are redirected to their respective dashboards.</p>
 *
 * <p>Mapped to: {@code /profile}</p>
 *
 * @see ProfileUpdateServlet
 * @see SessionUtil
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    /**
     * Handles GET requests to render the passenger profile view.
     *
     * <p>Validates the authenticated session and enforces role-based access.
     * Consumes any pending flash success attribute from the session before
     * binding the user entity to the request scope and forwarding to the
     * profile JSP.</p>
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

        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        if ("STAFF".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
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
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                .forward(request, response);
    }
}