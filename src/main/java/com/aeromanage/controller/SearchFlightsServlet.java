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

@WebServlet("/search-flights")
public class SearchFlightsServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retain user session state for header rendering
        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            request.setAttribute("user", user);
        }

        // 1. Intercept the new global header search parameter
        String query = request.getParameter("query");

        // Form input parameters
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String departure = request.getParameter("departure");

        List<Map<String, Object>> filteredFlights;

        // 2. Routing Decision Block
        if (query != null && !query.trim().isEmpty()) {
            // Path A: Global header search executed (Searches city/airline name via keyword)
            // Note: If you haven't declared searchFlightsByKeyword in your interface yet, we will do it next.
            filteredFlights = adminDao.searchFlightsByKeyword(query.trim());

            // Retain search parameter text for view context
            request.setAttribute("query", query);

        } else if (from != null && !from.trim().isEmpty() &&
                to != null && !to.trim().isEmpty() &&
                departure != null && !departure.trim().isEmpty()) {

            // Path B: Traditional explicit home form search
            filteredFlights = adminDao.searchFlights(from.trim(), to.trim(), departure.trim());
        } else {
            // Path C: Fallback default list display
            filteredFlights = adminDao.getAllFlights();
        }

        // Keep standard parameters intact for existing UI mappings
        request.setAttribute("flights", filteredFlights);
        request.setAttribute("searchedFrom", from);
        request.setAttribute("searchedTo", to);
        request.setAttribute("searchedDate", departure);

        // Forward safely back to your exact results view file
        request.getRequestDispatcher("/WEB-INF/views/search-flights.jsp")
                .forward(request, response);
    }
}