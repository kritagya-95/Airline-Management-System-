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

/**
 * Servlet controller responsible for authenticating system users.
 *
 * <p>Handles both GET and POST requests at the login endpoint. GET requests
 * forward the client to the login view. POST requests process the submitted
 * credentials by verifying the email against the persistence layer and validating
 * the provided password against the stored BCrypt hash. On successful authentication,
 * the resolved user entity is stored in the session and the client is redirected
 * to the appropriate dashboard based on the assigned role.</p>
 *
 * <p>Unauthenticated or invalid credential attempts are forwarded back to the
 * login view with a generic error message to prevent user enumeration.</p>
 *
 * <p>Mapped to: {@code /login}</p>
 *
 * @see UserDao
 * @see PasswordUtil
 * @see SessionUtil
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    /**
     * Forwards the client to the login JSP view.
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} from the client
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} to the client
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                .forward(request, response);
    }

    /**
     * Processes login form submissions and authenticates the requesting user.
     *
     * <p>Resolves the user record by email from the persistence layer, verifies
     * the submitted password against the stored BCrypt hash, establishes a session
     * on success, and redirects the client to the role-appropriate entry point.
     * All credential failures produce a generic error message forwarded to the
     * login view.</p>
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} containing
     *                 {@code email} and {@code password} parameters
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} used for
     *                 forwarding on failure or redirecting on success
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
            return;
        }

        User user = userDao.findByEmail(email.trim());

        if (user == null || !PasswordUtil.checkPassword(password, user.getPassword())) {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
            return;
        }

        SessionUtil.setAttribute(request, "user", user);

        switch (user.getRole()) {
            case "ADMIN":
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
            case "STAFF":
                response.sendRedirect(request.getContextPath() + "/staff/dashboard");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}