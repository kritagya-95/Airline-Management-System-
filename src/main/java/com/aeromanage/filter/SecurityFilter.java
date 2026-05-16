package com.aeromanage.filter;

import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Intercepts requests to the /booking endpoint to ensure only authenticated
 * users can complete a flight reservation.
 */
@WebFilter("/booking")
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if required when the container starts up
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Fetching the user from session utility
        User user = (User) SessionUtil.getAttribute(httpRequest, "user");

        if (user != null) {
            // User is authenticated! Send them forward down the chain to BookingServlet
            chain.doFilter(request, response);
        } else {
            // User is a guest! Intercept the attempt.
            String flightId = httpRequest.getParameter("flightId");
            String contextPath = httpRequest.getContextPath();

            // Constructing clean query parameters to guide the login page behavior
            StringBuilder redirectUrl = new StringBuilder(contextPath).append("/login?msg=auth_required");

            if (flightId != null && !flightId.trim().isEmpty()) {
                redirectUrl.append("&redirect=booking&flightId=").append(flightId.trim());
            }

            // Halt execution and issue a redirect to the login gate
            httpResponse.sendRedirect(redirectUrl.toString());
        }
    }

    @Override
    public void destroy() {
        // Cleanup resources if necessary when the servlet context is destroyed
    }
}