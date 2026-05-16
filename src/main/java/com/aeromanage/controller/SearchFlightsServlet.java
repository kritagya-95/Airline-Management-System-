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

        // 1. Maintain user session context profile details
        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            request.setAttribute("user", user);
        }

        // 2. Extract input names exactly matching the JSP form's 'name' attributes
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String departure = request.getParameter("departure");

        List<Map<String, Object>> filteredFlights;

        // 3. Conditional search routing
        if (from != null && !from.trim().isEmpty() &&
                to != null && !to.trim().isEmpty() &&
                departure != null && !departure.trim().isEmpty()) {

            // Hand off filtered parameter query variables directly to the DB layer
            filteredFlights = adminDao.searchFlights(from.trim(), to.trim(), departure.trim());
        } else {
            // Fallback default: load full inventory records if fields are empty or missing
            filteredFlights = adminDao.getAllFlights();
        }

        // 4. Send the payload list and re-populate the inputs so they don't vanish
        request.setAttribute("flights", filteredFlights);
        request.setAttribute("searchedFrom", from);
        request.setAttribute("searchedTo", to);
        request.setAttribute("searchedDate", departure);

        //Dispatches the results straight to your new dedicated search page layout
        request.getRequestDispatcher("/WEB-INF/views/staff/search-flights.jsp")
                .forward(request, response);
    }
}