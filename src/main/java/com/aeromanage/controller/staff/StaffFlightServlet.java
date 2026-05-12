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

@WebServlet("/staff/flights")
public class StaffFlightServlet extends HttpServlet {

    private final StaffDao staffDao = new StaffDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null || !"STAFF".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String flightIdStr = request.getParameter("flightId");
        String newStatus   = request.getParameter("newStatus");
        String reason      = request.getParameter("reason");

        if (flightIdStr == null || newStatus == null || flightIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        int flightId = Integer.parseInt(flightIdStr.trim());

        boolean updated = staffDao.updateFlightStatus(
                flightId,
                newStatus.trim(),
                user.getUserId(),
                reason != null ? reason.trim() : ""
        );

        if (updated) {
            request.getSession().setAttribute("flashSuccess",
                    "Flight status updated to " + newStatus + " successfully.");
        } else {
            request.getSession().setAttribute("flashError",
                    "Failed to update flight status. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/staff/dashboard");
    }
}