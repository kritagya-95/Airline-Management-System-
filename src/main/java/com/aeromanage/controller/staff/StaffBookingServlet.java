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
import java.util.Map;

@WebServlet("/staff/booking")
public class StaffBookingServlet extends HttpServlet {

    private final StaffDao staffDao = new StaffDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null || !"STAFF".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String ref = request.getParameter("ref");

        if (ref != null && !ref.trim().isEmpty()) {
            Map<String, Object> booking =
                    staffDao.findBookingByReference(ref.trim().toUpperCase());

            if (booking != null) {
                request.setAttribute("booking", booking);
            } else {
                request.setAttribute("bookingError",
                        "No booking found with reference: " + ref.trim().toUpperCase());
            }
        }

        request.setAttribute("searchRef",            ref);
        request.setAttribute("staff",                user);
        request.setAttribute("todayFlights",         staffDao.getTodayFlights());
        request.setAttribute("totalPassengersToday", staffDao.countPassengersToday());
        request.setAttribute("totalTodayFlights",    staffDao.countTodayFlights());

        request.getRequestDispatcher("/WEB-INF/views/staff/staffDashboard.jsp")
                .forward(request, response);
    }
}