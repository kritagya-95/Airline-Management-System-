package com.aeromanage.controller;

import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * HomeServlet — serves the SkyLine home/landing page.
 * Accessible by everyone (guests and logged-in users).
 * Passes the logged-in user to JSP if a session exists.
 * URL: /home
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pass user to JSP if logged in (header will show name + logout)
        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                .forward(request, response);
    }
}