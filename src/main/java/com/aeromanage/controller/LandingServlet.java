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
 * Servlet controller responsible for rendering the public landing page.
 *
 * <p>Serves as the application entry point for unauthenticated users. If an active
 * authenticated session is detected, the client is redirected directly to the home
 * page to avoid presenting the landing page to already logged-in users.</p>
 *
 * <p>Mapped to: {@code /landing}</p>
 *
 * @see SessionUtil
 */
@WebServlet("/landing")
public class LandingServlet extends HttpServlet {

    /**
     * Handles GET requests to render the public landing page.
     *
     * <p>Checks for an existing authenticated session and redirects to {@code /home}
     * if one is found. Unauthenticated requests are forwarded to the landing JSP.</p>
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} from the client
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} to the client
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/landing.jsp")
                .forward(request, response);
    }
}