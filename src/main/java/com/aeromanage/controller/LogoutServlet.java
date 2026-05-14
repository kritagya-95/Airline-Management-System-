package com.aeromanage.controller;

import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet controller responsible for terminating authenticated user sessions.
 *
 * <p>Invalidates the current HTTP session via {@link SessionUtil} and redirects
 * the client to the home page. Handles GET requests to support standard
 * logout link behaviour.</p>
 *
 * <p>Mapped to: {@code /logout}</p>
 *
 * @see SessionUtil
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    /**
     * Invalidates the current session and redirects the client to the home page.
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} from the client
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} to the client
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SessionUtil.invalidateSession(request);
        response.sendRedirect(request.getContextPath() + "/home");
    }
}