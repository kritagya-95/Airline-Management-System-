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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null) email = email.trim();
        if (password != null) password = password.trim();

        User user = userDao.findByEmail(email);

        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {

            SessionUtil.setAttribute(request, "user", user);

            String role = (user.getRole() != null) ? user.getRole().trim().toUpperCase() : "";
            String contextPath = request.getContextPath();

            System.out.println("[Login] Authorized: " + email + " as " + role);

            String redirectTarget = request.getParameter("redirect");
            String flightId = request.getParameter("flightId");

            if ("booking".equals(redirectTarget) && flightId != null && !flightId.trim().isEmpty()) {
                System.out.println("[Login] Intercept detected. Rerouting user directly to checkout for flight ID: " + flightId);
                response.sendRedirect(contextPath + "/booking?flightId=" + flightId.trim());
                return;
            }

            switch (role) {
                case "ADMIN":
                    response.sendRedirect(contextPath + "/admin/dashboard");
                    break;
                case "STAFF":
                    response.sendRedirect(contextPath + "/staff/dashboard");
                    break;
                default:
                    response.sendRedirect(contextPath + "/profile");
                    break;
            }
        } else {
            System.out.println("[Login] Refused: " + email);
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}