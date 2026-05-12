package com.aeromanage.controller.staff;

import com.aeromanage.dao.StaffDao;
import com.aeromanage.dao.StaffDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {

    private final StaffDao staffDao = new StaffDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null || !"STAFF".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("staff",                user);

        // Existing
        request.setAttribute("todayFlights",         staffDao.getTodayFlights());
        request.setAttribute("totalPassengersToday", staffDao.countPassengersToday());
        request.setAttribute("totalTodayFlights",    staffDao.countTodayFlights());

        // New
        request.setAttribute("allFlights",           staffDao.getAllFlights());
        request.setAttribute("statusHistory",        staffDao.getFlightStatusHistory());
        request.setAttribute("passengerList",        staffDao.getAllPassengers());
        request.setAttribute("recentBookings",       staffDao.getRecentBookings());
        request.setAttribute("cancelledBookings",    staffDao.getCancelledBookings());

        request.getRequestDispatcher("/WEB-INF/views/staff/staffDashboard.jsp")
                .forward(request, response);
    }
}