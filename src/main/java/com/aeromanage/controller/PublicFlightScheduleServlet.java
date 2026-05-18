package com.aeromanage.controller;

import com.aeromanage.dao.FlightScheduleDao;
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

@WebServlet("/public-schedule")
public class PublicFlightScheduleServlet extends HttpServlet {

    private final FlightScheduleDao scheduleDao = new FlightScheduleDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pull the flight list from the DAO layer
        List<Map<String, Object>> flights = scheduleDao.searchPublicSchedules(null, null);

        // Debug Verification: Print out to verify the collection isn't empty inside the servlet context
        System.out.println("Servlet diagnostic check: items count -> " + (flights != null ? flights.size() : "NULL"));

        // CRITICAL STRING BINDING MATCH: "scheduledFlights" must match the JSP's items key exactly
        request.setAttribute("scheduledFlights", flights);

        // Forward safely into the internal JSP view layer path
        request.getRequestDispatcher("/WEB-INF/views/public-schedule.jsp")
                .forward(request, response);
    }
}