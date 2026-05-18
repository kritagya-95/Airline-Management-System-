package com.aeromanage.controller;

import com.aeromanage.dao.FlightScheduleDao; // Added Interface Import
import com.aeromanage.dao.FlightScheduleDaoImpl;
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

@WebServlet("/book-flight-schedule")
public class PublicFlightScheduleServlet extends HttpServlet {

    // Programmed to the Interface to match your standard DAO architecture patterns
    private final FlightScheduleDao scheduleDao = new FlightScheduleDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Binds user session info if a traveler happens to be logged in
        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            request.setAttribute("user", user);
        }

        // Catch filtration properties from your interactive route lookup form
        String origin = request.getParameter("originCity");
        String destination = request.getParameter("destCity");

        // Execute query lookup execution against our decoupled interface layer
        List<Map<String, Object>> scheduledFlights = scheduleDao.searchPublicSchedules(origin, destination);

        // Expose items straight to the view layer attributes
        request.setAttribute("scheduledFlights", scheduledFlights);
        request.setAttribute("searchedOrigin", origin != null ? origin.trim() : "");
        request.setAttribute("searchedDest", destination != null ? destination.trim() : "");

        // Forward to the specific isolated view file
        request.getRequestDispatcher("/WEB-INF/views/public-schedule.jsp")
                .forward(request, response);
    }
}