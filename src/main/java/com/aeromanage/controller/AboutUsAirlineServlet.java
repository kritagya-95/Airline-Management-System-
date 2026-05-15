package com.aeromanage.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet controller responsible for rendering the public about-us page.
 *
 * <p>Mapped to: {@code /aboutus-airline}</p>
 */
@WebServlet("/aboutus-airline")
public class AboutUsAirlineServlet extends HttpServlet {

    /**
     * Handles GET requests to render the public about-us page.
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} from the client
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} to the client
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/aboutus-airline.jsp")
                .forward(request, response);
    }
}
