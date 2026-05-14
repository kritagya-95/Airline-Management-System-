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
 * ProfileUpdateServlet — handles POST from the profile edit form.
 * URL: /profile/update
 */
@WebServlet("/profile/update")
public class ProfileUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        // Must be logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String email     = request.getParameter("email");
        String phone     = request.getParameter("phone");

        // Basic validation
        if (firstName == null || firstName.trim().isEmpty() ||
                email     == null || email.trim().isEmpty()) {
            request.setAttribute("user",     user);
            request.setAttribute("errorMsg", "First name and email are required.");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                    .forward(request, response);
            return;
        }

        // Build updated full name
        String fullName = firstName.trim();
        if (lastName != null && !lastName.trim().isEmpty()) {
            fullName += " " + lastName.trim();
        }

        // Apply updates to user object
        user.setFullName(fullName);
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");

        boolean updated = userDao.update(user);

        if (updated) {
            // Refresh the session with updated user data
            SessionUtil.setAttribute(request, "user", user);
            request.setAttribute("user",        user);
            request.setAttribute("showSuccess", true);
        } else {
            request.setAttribute("user",     user);
            request.setAttribute("errorMsg", "Update failed. Please try again.");
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                .forward(request, response);
    }
}