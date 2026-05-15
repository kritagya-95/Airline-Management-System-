package com.aeromanage.filter;

import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Security filter responsible for enforcing Role-Based Access Control (RBAC).
 *
 * <p>Intercepts requests to protected resources (/admin/*, /staff/*, /profile/*).
 * It verifies the existence of a valid session and ensures the authenticated user
 * possesses the required role for the requested URI. Unauthorized access attempts
 * result in a redirect to the login view or a 403 Forbidden error.</p>
 *
 * <p>Mapped patterns: {@code /admin/*}, {@code /staff/*}, {@code /profile/*}</p>
 */
@WebFilter(urlPatterns = {"/admin/*", "/staff/*", "/profile/*"})
public class AuthenticationFilter implements Filter {

    /**
     * Filters the request to ensure the user is authenticated and authorized.
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // false ensures we don't create a new session just by checking for one
        HttpSession session = httpRequest.getSession(false);
        String contextPath = httpRequest.getContextPath();
        String requestURI = httpRequest.getRequestURI();

        // 1. Authentication Check: Retrieve user from session
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // User not logged in, redirect to login with a hint
            httpResponse.sendRedirect(contextPath + "/login?error=unauthorized");
            return;
        }

        // 2. Authorization Check: Role-Based Access Control

        // Admin Access Control
        if (requestURI.contains("/admin/")) {
            if (!"ADMIN".equals(user.getRole())) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Access Denied: You do not have permission to access the Administrative area.");
                return;
            }
        }

        // Staff Access Control
        if (requestURI.contains("/staff/")) {
            // Both ADMIN and STAFF can access staff-level operations
            if (!"STAFF".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Access Denied: You do not have permission to access the Staff area.");
                return;
            }
        }

        // 3. Authorization successful, proceed to the next filter or servlet in the chain
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}
