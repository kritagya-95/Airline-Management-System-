package com.aeromanage.controller;

import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.PasswordUtil;
import com.aeromanage.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/profile/password")
public class ProfilePasswordUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user == null || !"PASSENGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || confirmPassword == null
                || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("user", user);
            request.setAttribute("passwordError", "Both password fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("user", user);
            request.setAttribute("passwordError", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        boolean updated = userDao.updatePassword(
                user.getUserId(),
                PasswordUtil.hashPassword(newPassword)
        );

        if (updated) {
            request.getSession().setAttribute("profileSuccessMsg", "Your password has been changed successfully.");
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("user", user);
            request.setAttribute("passwordError", "Password update failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        }
    }
}
