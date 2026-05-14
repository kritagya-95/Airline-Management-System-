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

/**
 * Servlet controller responsible for processing new user registration requests.
 *
 * <p>Handles GET requests by forwarding to the registration view and POST requests
 * by validating submitted registration data, determining the appropriate role and
 * status based on the provided email domain and registration key, hashing the
 * password via BCrypt, and persisting the new user entity through the data access layer.</p>
 *
 * <p>Role assignment logic:</p>
 * <ul>
 *   <li>{@code ADMIN} — email domain {@code @skyline.admin.com} with valid admin key</li>
 *   <li>{@code STAFF} — email domain {@code @skyline.staff.com} with valid staff key</li>
 *   <li>{@code PASSENGER} — all other registrations, status set to {@code PENDING}</li>
 * </ul>
 *
 * <p>Staff registrations trigger automatic creation of a corresponding staff record
 * in the persistence layer via {@link UserDao#saveStaffRecord(int)}.</p>
 *
 * <p>Mapped to: {@code /register}</p>
 *
 * @see UserDao
 * @see PasswordUtil
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    /**
     * Forwards the client to the registration JSP view.
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} from the client
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} to the client
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                .forward(request, response);
    }

    /**
     * Processes the registration form submission and persists the new user account.
     *
     * <p>Performs server-side validation of all required fields, verifies password
     * confirmation match, checks for duplicate email addresses, determines role and
     * status assignments, hashes the provided password, and delegates persistence
     * to {@link UserDao}. On success, the client is forwarded to the login view
     * with a contextual success message. On failure, the registration view is
     * re-rendered with an appropriate error message.</p>
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} containing
     *                 registration form parameters
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} used for
     *                 forwarding the client to the appropriate view
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName       = request.getParameter("firstName");
        String lastName        = request.getParameter("lastName");
        String email           = request.getParameter("email");
        String phone           = request.getParameter("phone");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String adminKey        = request.getParameter("adminKey");
        String staffKey        = request.getParameter("staffKey");

        // Server-side presence validation
        if (firstName == null || firstName.trim().isEmpty()
                || lastName == null || lastName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
            return;
        }

        // Password confirmation validation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
            return;
        }

        // Duplicate email validation
        if (userDao.findByEmail(email.trim()) != null) {
            request.setAttribute("error", "An account with this email address already exists.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
            return;
        }

        // Role and status resolution
        String emailLower = email.toLowerCase().trim();
        String role;
        String status;
        String successMessage;

        if (emailLower.endsWith("@skyline.admin.com")
                && "JavaHut-SkyLine Admin".equals(adminKey)) {
            role           = "ADMIN";
            status         = "APPROVED";
            successMessage = "Admin account created successfully. You may now log in.";

        } else if (emailLower.endsWith("@skyline.staff.com")
                && "Java-Hut Skyline Staff".equals(staffKey)) {
            role           = "STAFF";
            status         = "APPROVED";
            successMessage = "Staff account created successfully. You may now log in.";

        } else {
            role           = "PASSENGER";
            status         = "PENDING";
            successMessage = "Registration successful. Your account is pending administrator approval.";
        }

        // Build and persist user entity
        User user = new User();
        user.setFullName(firstName.trim() + " " + lastName.trim());
        user.setEmail(email.trim());
        user.setPhone(phone.trim());
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole(role);
        user.setStatus(status);

        boolean saved = userDao.save(user);

        if (saved) {
            if ("STAFF".equals(role)) {
                userDao.saveStaffRecord(user.getUserId());
            }
            request.setAttribute("success", successMessage);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed due to a server error. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                    .forward(request, response);
        }
    }
}