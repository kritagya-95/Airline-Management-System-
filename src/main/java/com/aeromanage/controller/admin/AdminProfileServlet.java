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
 * * <p>Security (Authentication and Authorization) is now handled by the
 * AuthenticationFilter. This servlet focuses on data display and session-scoped
 * flash message consumption.</p>
 */
@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve the authenticated admin (Guaranteed by AuthenticationFilter)
        User user = (User) SessionUtil.getAttribute(request, "user");

        // 2. Flash Attribute Consumption
        // Read and immediately remove the success flag to prevent it from showing again on refresh
        HttpSession session = request.getSession(false);
        if (session != null) {
            Boolean success = (Boolean) session.getAttribute("profileUpdateSuccess");
            if (Boolean.TRUE.equals(success)) {
                request.setAttribute("showSuccess", true);
                session.removeAttribute("profileUpdateSuccess");
            }
        }

        // 3. Bind user data for the JSP
        request.setAttribute("user", user);

        // 4. Forward to the view
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-profile.jsp")
                .forward(request, response);
    }
}