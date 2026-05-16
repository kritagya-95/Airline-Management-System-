package com.aeromanage.controller;

import com.aeromanage.dao.PassengerBookingDao;
import com.aeromanage.dao.PassengerBookingDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/flight-schedule")
public class FlightScheduleServlet extends HttpServlet {

    private final PassengerBookingDao bookingDao = new PassengerBookingDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"PASSENGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("user", user);
        request.setAttribute("currentBookings", bookingDao.getCurrentBookings(user.getUserId()));
        request.setAttribute("recentBookings", bookingDao.getRecentBookings(user.getUserId()));
        request.setAttribute("pastBookings", bookingDao.getPastBookings(user.getUserId()));
        request.getRequestDispatcher("/WEB-INF/views/flightschedule.jsp")
                .forward(request, response);
    }
}
