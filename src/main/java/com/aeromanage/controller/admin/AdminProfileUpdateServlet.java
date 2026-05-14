package com.aeromanage.controller.admin;

import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet controller responsible for processing admin profile update requests.
 *
 * <p>Accepts POST submissions from the admin profile edit form, performs server-side
 * validation, persists the updated user record via {@link UserDao}, and refreshes
 * the authenticated session with the updated entity. On success, a flash message flag
 * is stored in the session and the client is redirected following the
 * Post-Redirect-Get pattern to prevent duplicate form submissions on browser refresh.</p>
 *
 * <p>Mapped to: {@code /admin/profile/update}</p>
 *
 * @see UserDao
 * @see SessionUtil
 */
@WebServlet("/admin/profile/update")
public class AdminProfileUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    /**
     * Processes the admin profile update form submission.
     *
     * <p>Validates the presence of required fields ({@code fullName}, {@code email})
     * before applying updates to the authenticated user entity. On validation failure,
     * the request is forwarded back to the profile view with an appropriate error message.
     * On persistence success, the session user object is refreshed, a flash flag is set,
     * and the client is redirected to {@code /admin/profile}.</p>
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} containing
     *                 the updated profile field parameters
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} used for
     *                 forwarding on failure or redirecting on success
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            request.setAttribute("user",     user);
            request.setAttribute("errorMsg", "Full name and email are required.");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                    .forward(request, response);
            return;
        }

        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");

        boolean updated = userDao.update(user);

        if (updated) {
            SessionUtil.setAttribute(request, "user", user);
            request.getSession().setAttribute("profileUpdateSuccess", true);
            response.sendRedirect(request.getContextPath() + "/admin/profile");
        } else {
            request.setAttribute("user",     user);
            request.setAttribute("errorMsg", "Profile update failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                    .forward(request, response);
        }
    }
}