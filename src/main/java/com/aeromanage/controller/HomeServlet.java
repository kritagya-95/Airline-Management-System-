package com.aeromanage.controller;

import com.aeromanage.dao.AdminDao;
import com.aeromanage.dao.AdminDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet controller responsible for rendering the primary home page of the application.
 *
 * <p>Accessible to both authenticated and unauthenticated users. Retrieves the current
 * flight inventory from the persistence layer for display in the popular flights section.
 * If an authenticated session exists, the resolved user entity is bound to the request
 * scope to enable personalised rendering in the view layer.</p>
 *
 * <p>Mapped to: {@code /home}</p>
 *
 * @see AdminDao
 * @see SessionUtil
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    /**
     * Handles GET requests to render the home page view.
     *
     * <p>Resolves the authenticated user from the session if present and fetches
     * the full flight list from the persistence layer. Both are bound to the request
     * scope prior to forwarding to the home JSP.</p>
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
            request.setAttribute("user", user);
        }

        List<Map<String, Object>> flights = adminDao.getAllFlights();
        request.setAttribute("flights", flights);

        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                .forward(request, response);
    }
}
