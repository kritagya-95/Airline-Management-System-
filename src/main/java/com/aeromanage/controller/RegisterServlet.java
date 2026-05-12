package com.aeromanage.controller;

import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDao.findByEmail(email) != null) {
            request.setAttribute("error", "Email address is already registered.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }



// ====================== AUTO ADMIN LOGIC ======================
        String emailLower = email.toLowerCase().trim();
        String adminKey = request.getParameter("adminKey");

        boolean isAdmin = emailLower.endsWith("@skyline.admin.com")
                && "JavaHut-SkyLine".equals(adminKey);

        String role   = isAdmin ? "ADMIN"    : "PASSENGER";
        String status = isAdmin ? "APPROVED" : "PENDING";

        User user = new User();
        user.setFullName(firstName + " " + lastName);
        user.setEmail(email.trim());
        user.setPhone(phone);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole(role);
        user.setStatus(status);

        boolean saved = userDao.save(user);

        if (saved) {
            if (isAdmin) {
                request.setAttribute("success", "Admin account created successfully! You can login now.");
            } else {
                request.setAttribute("success", " Account created successfully! Please wait for admin approval.");
            }
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}