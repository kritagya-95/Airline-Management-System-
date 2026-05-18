package com.aeromanage.controller;

import com.aeromanage.entity.User;
import com.aeromanage.utils.DBConnection;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = resolvePassenger(request, response);
        if (user == null) {
            return;
        }

        String step = request.getParameter("step");
        Integer bookingId = parseInt(request.getParameter("bookingId"));
        Integer flightId = parseInt(request.getParameter("flightId"));

        if (step == null || step.trim().isEmpty()) {
            step = "passenger";
        }

        if ("passenger".equals(step) && flightId == null) {
            response.sendRedirect(request.getContextPath() + "/book-flight");
            return;
        }

        Map<String, Object> flight = flightId != null ? findFlight(flightId) : null;
        Map<String, Object> booking = bookingId != null ? findBooking(user.getUserId(), bookingId) : null;

        if (!"passenger".equals(step) && booking == null) {
            response.sendRedirect(request.getContextPath() + "/book-flight");
            return;
        }

        if (booking != null && flight == null) {
            flight = findFlight(((Number) booking.get("flight_id")).intValue());
        }

        if ("confirmation".equals(step) && !hasSelectedSeat(user.getUserId(), bookingId)) {
            response.sendRedirect(request.getContextPath()
                    + "/seat-selection?bookingId=" + bookingId
                    + "&flightId=" + booking.get("flight_id")
                    + "&next=" + encodeNext("/booking?step=confirmation&bookingId=" + bookingId));
            return;
        }

        if ("payment".equals(step) && !isBookingConfirmed(request, bookingId)) {
            response.sendRedirect(request.getContextPath()
                    + "/booking?step=confirmation&bookingId=" + bookingId);
            return;
        }

        bindCommon(request, user, step, flight, booking);
        request.getRequestDispatcher("/WEB-INF/views/booknow.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = resolvePassenger(request, response);
        if (user == null) {
            return;
        }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createBooking(request, response, user);
            return;
        }

        if ("confirm".equals(action)) {
            Integer bookingId = parseInt(request.getParameter("bookingId"));
            if (bookingId != null && findBooking(user.getUserId(), bookingId) != null
                    && hasSelectedSeat(user.getUserId(), bookingId)) {
                request.getSession().setAttribute(confirmKey(bookingId), Boolean.TRUE);
                response.sendRedirect(request.getContextPath()
                        + "/booking?step=payment&bookingId=" + bookingId);
                return;
            }

            response.sendRedirect(request.getContextPath()
                    + "/booking?step=confirmation&bookingId=" + bookingId);
            return;
        }

        if ("pay".equals(action)) {
            completePayment(request, response, user);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/book-flight");
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        Integer flightId = parseInt(request.getParameter("flightId"));
        String fullName = request.getParameter("fullName");
        String passportNo = request.getParameter("passportNo");
        String dob = request.getParameter("dob");
        String nationality = request.getParameter("nationality");
        String ticketClass = request.getParameter("ticketClass");

        if (flightId == null || isBlank(fullName) || isBlank(ticketClass)) {
            response.sendRedirect(request.getContextPath()
                    + "/booking?flightId=" + (flightId == null ? "" : flightId)
                    + "&error=missing");
            return;
        }

        Map<String, Object> flight = findFlight(flightId);
        if (flight == null) {
            response.sendRedirect(request.getContextPath() + "/book-flight");
            return;
        }

        BigDecimal fare = resolveFare(flight, ticketClass);
        Integer bookingId = insertBookingWithPassenger(
                user.getUserId(),
                flightId,
                fullName.trim(),
                passportNo,
                dob,
                nationality,
                ticketClass,
                fare
        );

        if (bookingId == null) {
            response.sendRedirect(request.getContextPath()
                    + "/booking?flightId=" + flightId
                    + "&error=save");
            return;
        }

        response.sendRedirect(request.getContextPath()
                + "/seat-selection?bookingId=" + bookingId
                + "&flightId=" + flightId
                + "&next=" + encodeNext("/booking?step=confirmation&bookingId=" + bookingId));
    }

    private void completePayment(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        Integer bookingId = parseInt(request.getParameter("bookingId"));
        String method = request.getParameter("paymentMethod");

        if (bookingId == null || (!"ESEWA".equals(method) && !"KHALTI".equals(method))) {
            response.sendRedirect(request.getContextPath()
                    + "/booking?step=payment&bookingId=" + bookingId);
            return;
        }

        Map<String, Object> booking = findBooking(user.getUserId(), bookingId);
        if (booking == null || !isBookingConfirmed(request, bookingId)
                || !hasSelectedSeat(user.getUserId(), bookingId)) {
            response.sendRedirect(request.getContextPath()
                    + "/booking?step=confirmation&bookingId=" + bookingId);
            return;
        }

        boolean completed = savePaymentAndTicket(bookingId, method);
        if (!completed) {
            response.sendRedirect(request.getContextPath()
                    + "/booking?step=payment&bookingId=" + bookingId
                    + "&error=payment");
            return;
        }

        request.getSession().removeAttribute(confirmKey(bookingId));
        response.sendRedirect(request.getContextPath()
                + "/booking?step=success&bookingId=" + bookingId);
    }

    private User resolvePassenger(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) SessionUtil.getAttribute(request, "user");

        if (user == null) {
            Integer flightId = parseInt(request.getParameter("flightId"));
            String redirect = request.getContextPath() + "/login?redirect=booking";
            if (flightId != null) {
                redirect += "&flightId=" + flightId;
            }
            response.sendRedirect(redirect);
            return null;
        }

        if (!"PASSENGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return null;
        }

        return user;
    }

    private void bindCommon(HttpServletRequest request, User user, String step,
                            Map<String, Object> flight, Map<String, Object> booking) {
        request.setAttribute("user", user);
        request.setAttribute("step", step);
        request.setAttribute("flight", flight);
        request.setAttribute("booking", booking);

        if (booking != null) {
            int bookingId = ((Number) booking.get("booking_id")).intValue();
            List<Map<String, Object>> selectedSeats = findSelectedSeats(user.getUserId(), bookingId);
            request.setAttribute("selectedSeats", selectedSeats);
            request.setAttribute("selectedSeat", selectedSeats.isEmpty() ? null : selectedSeats.get(0));
            request.setAttribute("payment", findPayment(bookingId));
            request.setAttribute("ticket", findTicket(bookingId));
        }
    }

    private Map<String, Object> findFlight(int flightId) {
        String sql = """
                SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
                       f.status, f.base_economy_fare, f.base_business_fare, f.base_first_fare,
                       al.airline_name,
                       oa.iata_code AS origin_code, oa.city AS origin_city,
                       da.iata_code AS dest_code, da.city AS dest_city
                FROM flights f
                JOIN airlines al ON al.airline_id = f.airline_id
                JOIN airports oa ON oa.airport_id = f.origin_airport_id
                JOIN airports da ON da.airport_id = f.dest_airport_id
                WHERE f.flight_id = ?
                """;
        return findSingle(sql, flightId);
    }

    private Map<String, Object> findBooking(int userId, int bookingId) {
        String sql = """
                SELECT b.booking_id, b.user_id, b.flight_id, b.booking_ref,
                       b.class, b.num_passengers, b.total_fare, b.booking_status,
                       b.created_at,
                       bp.passenger_id, bp.full_name AS passenger_name,
                       bp.passport_no, bp.dob, bp.nationality
                FROM bookings b
                LEFT JOIN booking_passengers bp ON bp.booking_id = b.booking_id
                WHERE b.booking_id = ?
                  AND b.user_id = ?
                """;
        return findSingle(sql, bookingId, userId);
    }

    private Map<String, Object> findSelectedSeat(int userId, int bookingId) {
        List<Map<String, Object>> selectedSeats = findSelectedSeats(userId, bookingId);
        return selectedSeats.isEmpty() ? null : selectedSeats.get(0);
    }

    private List<Map<String, Object>> findSelectedSeats(int userId, int bookingId) {
        String sql = """
                SELECT ss.selected_seat_id, s.seat_number, s.class
                FROM selected_seats ss
                JOIN seats s ON s.seat_id = ss.seat_id
                WHERE ss.booking_id = ?
                  AND ss.passenger_id = ?
                ORDER BY s.seat_number
                """;
        return findRows(sql, bookingId, userId);
    }

    private Map<String, Object> findPayment(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ?";
        return findSingle(sql, bookingId);
    }

    private Map<String, Object> findTicket(int bookingId) {
        String sql = "SELECT * FROM tickets WHERE booking_id = ?";
        return findSingle(sql, bookingId);
    }

    private boolean hasSelectedSeat(int userId, Integer bookingId) {
        if (bookingId == null) {
            return false;
        }

        return findSelectedSeat(userId, bookingId) != null;
    }

    private Integer insertBookingWithPassenger(int userId, int flightId, String fullName,
                                               String passportNo, String dob, String nationality,
                                               String ticketClass, BigDecimal fare) {
        String insertBooking = """
                INSERT INTO bookings (user_id, flight_id, booking_ref, class, num_passengers, total_fare, booking_status)
                VALUES (?, ?, ?, ?, 1, ?, 'PENDING')
                """;
        String insertPassenger = """
                INSERT INTO booking_passengers (booking_id, full_name, passport_no, dob, nationality)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                int bookingId;
                try (PreparedStatement ps = conn.prepareStatement(insertBooking, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, flightId);
                    ps.setString(3, generateBookingRef());
                    ps.setString(4, ticketClass.toUpperCase());
                    ps.setBigDecimal(5, fare);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            conn.rollback();
                            return null;
                        }
                        bookingId = keys.getInt(1);
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(insertPassenger)) {
                    ps.setInt(1, bookingId);
                    ps.setString(2, fullName);
                    ps.setString(3, emptyToNull(passportNo));
                    if (isBlank(dob)) {
                        ps.setNull(4, java.sql.Types.DATE);
                    } else {
                        ps.setDate(4, java.sql.Date.valueOf(dob.trim()));
                    }
                    ps.setString(5, emptyToNull(nationality));
                    ps.executeUpdate();
                }

                conn.commit();
                return bookingId;
            } catch (SQLException | IllegalArgumentException e) {
                conn.rollback();
                System.err.println("[BookingServlet] insertBookingWithPassenger error: " + e.getMessage());
                return null;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("[BookingServlet] booking connection error: " + e.getMessage());
            return null;
        }
    }

    private boolean savePaymentAndTicket(int bookingId, String method) {
        String paymentSql = """
                INSERT INTO payments (booking_id, amount, currency, method, status, transaction_id, paid_at)
                SELECT booking_id, total_fare, 'NPR', ?, 'COMPLETED', ?, CURRENT_TIMESTAMP
                FROM bookings
                WHERE booking_id = ?
                ON DUPLICATE KEY UPDATE
                    method = VALUES(method),
                    status = 'COMPLETED',
                    transaction_id = VALUES(transaction_id),
                    paid_at = CURRENT_TIMESTAMP
                """;
        String updateBooking = "UPDATE bookings SET booking_status = 'CONFIRMED' WHERE booking_id = ?";
        String updatePassengerSeat = """
                UPDATE booking_passengers bp
                JOIN selected_seats ss ON ss.booking_id = bp.booking_id
                SET bp.seat_id = ss.seat_id
                WHERE bp.booking_id = ?
                """;
        String passengerSql = "SELECT passenger_id FROM booking_passengers WHERE booking_id = ? LIMIT 1";
        String ticketSql = """
                INSERT INTO tickets (booking_id, passenger_id, ticket_number, qr_data)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                String transactionId = method + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                try (PreparedStatement ps = conn.prepareStatement(paymentSql)) {
                    ps.setString(1, method);
                    ps.setString(2, transactionId);
                    ps.setInt(3, bookingId);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(updateBooking)) {
                    ps.setInt(1, bookingId);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(updatePassengerSeat)) {
                    ps.setInt(1, bookingId);
                    ps.executeUpdate();
                }

                Integer passengerId = null;
                try (PreparedStatement ps = conn.prepareStatement(passengerSql)) {
                    ps.setInt(1, bookingId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            passengerId = rs.getInt("passenger_id");
                        }
                    }
                }

                if (passengerId == null || findTicket(bookingId) != null) {
                    conn.commit();
                    return true;
                }

                String ticketNumber = "SKY" + UUID.randomUUID().toString()
                        .replace("-", "")
                        .substring(0, 12)
                        .toUpperCase();
                try (PreparedStatement ps = conn.prepareStatement(ticketSql)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, passengerId);
                    ps.setString(3, ticketNumber);
                    ps.setString(4, "Booking " + bookingId + " | Ticket " + ticketNumber);
                    ps.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("[BookingServlet] savePaymentAndTicket error: " + e.getMessage());
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("[BookingServlet] payment connection error: " + e.getMessage());
            return false;
        }
    }

    private Map<String, Object> findSingle(String sql, int... params) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setInt(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rowToMap(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[BookingServlet] findSingle error: " + e.getMessage());
        }

        return null;
    }

    private List<Map<String, Object>> findRows(String sql, int... params) {
        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setInt(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(rowToMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[BookingServlet] findRows error: " + e.getMessage());
        }

        return rows;
    }

    private BigDecimal resolveFare(Map<String, Object> flight, String ticketClass) {
        String normalized = ticketClass == null ? "ECONOMY" : ticketClass.toUpperCase();
        Object value;

        switch (normalized) {
            case "BUSINESS":
                value = flight.get("base_business_fare");
                break;
            case "FIRST":
                value = flight.get("base_first_fare");
                break;
            default:
                value = flight.get("base_economy_fare");
                break;
        }

        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }

        return new BigDecimal(String.valueOf(value));
    }

    private boolean isBookingConfirmed(HttpServletRequest request, Integer bookingId) {
        if (bookingId == null) {
            return false;
        }

        HttpSession session = request.getSession(false);
        return session != null && Boolean.TRUE.equals(session.getAttribute(confirmKey(bookingId)));
    }

    private String confirmKey(int bookingId) {
        return "bookNowConfirmed_" + bookingId;
    }

    private String generateBookingRef() {
        return UUID.randomUUID().toString()
                .replace("-", "")
                .substring(0, 10)
                .toUpperCase();
    }

    private String encodeNext(String next) {
        return URLEncoder.encode(next, StandardCharsets.UTF_8);
    }

    private String emptyToNull(String value) {
        return isBlank(value) ? null : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private Integer parseInt(String value) {
        if (isBlank(value)) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Map<String, Object> rowToMap(ResultSet rs) throws SQLException {
        Map<String, Object> row = new LinkedHashMap<>();
        ResultSetMetaData meta = rs.getMetaData();

        for (int i = 1; i <= meta.getColumnCount(); i++) {
            row.put(meta.getColumnLabel(i).toLowerCase(), rs.getObject(i));
        }

        return row;
    }
}
