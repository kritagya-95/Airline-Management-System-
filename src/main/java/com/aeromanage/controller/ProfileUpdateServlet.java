package com.aeromanage.controller;

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
 * Servlet controller responsible for processing passenger profile update requests.
 *
 * <p>Accepts POST submissions from the passenger profile edit form, performs
 * server-side validation, persists the updated user record via {@link UserDao},
 * and refreshes the authenticated session with the updated entity. On success,
 * a session-scoped flash attribute is set and the client is redirected to the
 * profile page following the Post-Redirect-Get pattern to prevent duplicate
 * form submissions on browser refresh.</p>
 *
 * <p>Mapped to: {@code /profile/update}</p>
 *
 * @see UserDao
 * @see SessionUtil
 */
@WebServlet("/profile/update")
public class ProfileUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    /**
     * Processes the passenger profile update form submission.
     *
     * <p>Validates the presence of required fields ({@code firstName}, {@code email})
     * before constructing the updated full name and applying changes to the authenticated
     * user entity. On validation failure, the request is forwarded back to the profile
     * view with an error message. On persistence success, the session is refreshed,
     * a flash flag is stored, and the client is redirected to {@code /profile}.</p>
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

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String email     = request.getParameter("email");
        String phone     = request.getParameter("phone");

        if (firstName == null || firstName.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            request.setAttribute("user",     user);
            request.setAttribute("errorMsg", "First name and email are required.");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                    .forward(request, response);
            return;
        }

        String fullName = firstName.trim();
        if (lastName != null && !lastName.trim().isEmpty()) {
            fullName += " " + lastName.trim();
        }

        user.setFullName(fullName);
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");

        boolean updated = userDao.update(user);

        if (updated) {
            SessionUtil.setAttribute(request, "user", user);
            request.getSession().setAttribute("profileUpdateSuccess", true);
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("user",     user);
            request.setAttribute("errorMsg", "Profile update failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                    .forward(request, response);
        }
    }
}