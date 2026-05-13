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
 * LandingServlet — serves the public landing page at root "/".
 * If the user is already logged in, redirect straight to /home.
 */
@WebServlet("/landing")
public class LandingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, skip landing and go to home
        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/landing.jsp")
                .forward(request, response);
    }
}