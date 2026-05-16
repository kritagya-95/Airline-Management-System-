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

@WebServlet("/my-bookings")
public class MyBookingsServlet extends HttpServlet {

    private final PassengerBookingDao bookingDao = new PassengerBookingDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = resolvePassenger(request, response);
        if (user == null) {
            return;
        }

        bindBookings(request, user.getUserId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/mybookings.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = resolvePassenger(request, response);
        if (user == null) {
            return;
        }

        String bookingIdValue = request.getParameter("bookingId");
        String reason = request.getParameter("reason");

        try {
            int bookingId = Integer.parseInt(bookingIdValue);
            boolean cancelled = bookingDao.cancelBooking(
                    user.getUserId(),
                    bookingId,
                    reason != null && !reason.trim().isEmpty()
                            ? reason.trim()
                            : "Cancelled by passenger"
            );
            request.getSession().setAttribute(
                    cancelled ? "bookingSuccess" : "bookingError",
                    cancelled ? "Booking cancellation recorded successfully." : "Unable to cancel this booking."
            );
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("bookingError", "Invalid booking selected.");
        }

        response.sendRedirect(request.getContextPath() + "/my-bookings");
    }

    private void bindBookings(HttpServletRequest request, int userId) {
        request.setAttribute("currentBookings", bookingDao.getCurrentBookings(userId));
        request.setAttribute("recentBookings", bookingDao.getRecentBookings(userId));
        request.setAttribute("pastBookings", bookingDao.getPastBookings(userId));
    }

    private User resolvePassenger(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        if (!"PASSENGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return null;
        }

        return user;
    }
}
