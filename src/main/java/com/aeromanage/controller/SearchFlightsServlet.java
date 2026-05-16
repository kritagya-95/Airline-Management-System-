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

        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            request.setAttribute("user", user);
        }

        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String departure = request.getParameter("departure");

        List<Map<String, Object>> filteredFlights;

        if (from != null && !from.trim().isEmpty() &&
                to != null && !to.trim().isEmpty() &&
                departure != null && !departure.trim().isEmpty()) {

            filteredFlights = adminDao.searchFlights(from.trim(), to.trim(), departure.trim());
        } else {
            filteredFlights = adminDao.getAllFlights();
        }

        request.setAttribute("flights", filteredFlights);
        request.setAttribute("searchedFrom", from);
        request.setAttribute("searchedTo", to);
        request.setAttribute("searchedDate", departure);

        // FORWARDS SECURELY TO YOUR DEDICATED VIEW PAGE
        request.getRequestDispatcher("/WEB-INF/views/staff/search-flights.jsp")
                .forward(request, response);
    }
}