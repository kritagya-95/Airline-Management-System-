package com.aeromanage.controller;

import com.aeromanage.dao.PassengerBookingDao;
import com.aeromanage.dao.PassengerBookingDaoImpl;
import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Servlet controller responsible for rendering the passenger profile page.
 *
 * <p>Resolves the authenticated user from the current session and forwards the
 * request to the passenger profile JSP view. Handles consumption of the
 * {@code profileUpdateSuccess} session-scoped flash attribute set by
 * {@link ProfileUpdateServlet} following a successful profile update, removing
 * it immediately after resolution to enforce single-display behaviour.</p>
 *
 * <p>Access is restricted to authenticated users holding the {@code PASSENGER} role.
 * Unauthenticated requests are redirected to the login endpoint. Admin and staff
 * users are redirected to their respective dashboards.</p>
 *
 * <p>Mapped to: {@code /profile}</p>
 *
 * @see ProfileUpdateServlet
 * @see SessionUtil
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();
    private final PassengerBookingDao bookingDao = new PassengerBookingDaoImpl();

    /**
     * Handles GET requests to render the passenger profile view.
     *
     * <p>Validates the authenticated session and enforces role-based access.
     * Consumes any pending flash success attribute from the session before
     * binding the user entity to the request scope and forwarding to the
     * profile JSP.</p>
     *
     * @param request  the {@link jakarta.servlet.http.HttpServletRequest} from the client
     * @param response the {@link jakarta.servlet.http.HttpServletResponse} to the client
     * @throws ServletException if the servlet encounters a processing error
     * @throws IOException      if an input/output error occurs during response handling
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User latestUser = userDao.findById(user.getUserId());
        if (latestUser == null) {
            SessionUtil.invalidateSession(request);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        user = latestUser;
        SessionUtil.setAttribute(request, "user", user);

        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        if ("STAFF".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            Boolean success = (Boolean) session.getAttribute("profileUpdateSuccess");
            if (Boolean.TRUE.equals(success)) {
                request.setAttribute("showSuccess", true);
                session.removeAttribute("profileUpdateSuccess");
            }
            String successMsg = (String) session.getAttribute("profileSuccessMsg");
            if (successMsg != null) {
                request.setAttribute("successMsg", successMsg);
                session.removeAttribute("profileSuccessMsg");
            }
        }

        request.setAttribute("user", user);
        request.setAttribute("profileBookings", getProfileBookings(user.getUserId()));
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                .forward(request, response);
    }

    private List<Map<String, Object>> getProfileBookings(int userId) {
        List<Map<String, Object>> bookings = new ArrayList<>();
        bookings.addAll(bookingDao.getCurrentBookings(userId));
        for (Map<String, Object> booking : bookingDao.getPastBookings(userId)) {
            if (!"CANCELLED".equals(booking.get("booking_status"))) {
                bookings.add(booking);
            }
        }
        return bookings;
    }
}
