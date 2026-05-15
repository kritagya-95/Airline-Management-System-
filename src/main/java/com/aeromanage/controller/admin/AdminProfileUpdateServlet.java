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
 * * <p>Security is enforced by the AuthenticationFilter. This servlet focuses on
 * validating input, persisting data via UserDao, and refreshing the session state.</p>
 */
@WebServlet("/admin/profile/update")
public class AdminProfileUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve the authenticated admin (Guaranteed by AuthenticationFilter)
        User user = (User) SessionUtil.getAttribute(request, "user");

        // 2. Extract and Validate Parameters
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {

            request.setAttribute("user", user);
            request.setAttribute("errorMsg", "Full name and email are required.");
            // Forward back to the form if validation fails
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                    .forward(request, response);
            return;
        }

        // 3. Update the Entity
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");

        // 4. Persist Changes
        boolean updated = userDao.update(user);

        if (updated) {
            // Update the user object in the session to reflect changes immediately
            SessionUtil.setAttribute(request, "user", user);

            // Set flash attribute for the success message (consumed by AdminProfileServlet)
            request.getSession().setAttribute("profileUpdateSuccess", true);

            // Post-Redirect-Get pattern
            response.sendRedirect(request.getContextPath() + "/admin/profile");
        } else {
            request.setAttribute("user", user);
            request.setAttribute("errorMsg", "Profile update failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                    .forward(request, response);
        }
    }
}