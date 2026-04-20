package com.aeromanage.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * HomeServlet - Displays the main SkyLine home page
 * (Login check removed temporarily for testing)
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Directly show the home page without checking login
        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                .forward(request, response);
    }
}