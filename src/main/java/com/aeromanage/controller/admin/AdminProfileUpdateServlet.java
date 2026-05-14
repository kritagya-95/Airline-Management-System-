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

@WebServlet("/admin/profile/update")
public class AdminProfileUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("user", user);
            request.setAttribute("errorMsg", "Full name and email are required.");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                    .forward(request, response);
            return;
        }

        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        if (phone != null) user.setPhone(phone.trim());

        boolean updated = userDao.update(user);

        if (updated) {
            SessionUtil.setAttribute(request, "user", user);
            request.setAttribute("user", user);
            request.setAttribute("showSuccess", true);
        } else {
            request.setAttribute("user", user);
            request.setAttribute("errorMsg", "Update failed. Please try again.");
        }

        // Updated path
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                .forward(request, response);
    }
}