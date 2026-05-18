package com.aeromanage.controller;

import com.aeromanage.entity.User;
import com.aeromanage.utils.DBConnection;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/seat-selection")
public class SeatSelectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = resolvePassenger(request, response);
        if (user == null) {
            return;
        }

        Integer bookingId = parseInt(request.getParameter("bookingId"));
        Integer flightId = parseInt(request.getParameter("flightId"));

        Map<String, Object> flight = findFlight(user.getUserId(), bookingId, flightId);
        if (flight == null) {
            request.setAttribute("seatError", "Flight details were not found for seat selection.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/seatselection.jsp")
                    .forward(request, response);
            return;
        }

        int resolvedFlightId = ((Number) flight.get("flight_id")).intValue();
        request.setAttribute("user", user);
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("flightId", resolvedFlightId);
        request.setAttribute("next", request.getParameter("next"));
        request.setAttribute("selected", request.getParameter("selected"));
        request.setAttribute("flight", flight);
        SeatPageData seatPageData = loadSeatPageData(resolvedFlightId, bookingId, user.getUserId());
        request.setAttribute("seats", seatPageData.seats);
        request.setAttribute("selectedSeats", seatPageData.selectedSeats);
        if (seatPageData.errorMessage != null) {
            request.setAttribute("seatError", seatPageData.errorMessage);
        }

        request.getRequestDispatcher("/WEB-INF/views/seatselection.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = resolvePassenger(request, response);
        if (user == null) {
            return;
        }

        Integer bookingId = parseInt(request.getParameter("bookingId"));
        Integer flightId = parseInt(request.getParameter("flightId"));
        List<Integer> seatIds = parseIntValues(request.getParameterValues("seatId"));
        String next = request.getParameter("next");

        if (bookingId == null || flightId == null || seatIds.isEmpty()) {
            redirectBack(request, response, bookingId, flightId, "Please select at least one available seat.", next);
            return;
        }

        boolean saved = saveSelectedSeats(user.getUserId(), bookingId, flightId, seatIds);
        if (!saved) {
            redirectBack(request, response, bookingId, flightId, "One or more selected seats are no longer available.", next);
            return;
        }

        if (next != null && !next.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + next.trim());
            return;
        }

        response.sendRedirect(request.getContextPath()
                + "/seat-selection?bookingId=" + bookingId
                + "&flightId=" + flightId
                + "&selected=success");
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

    private Map<String, Object> findFlight(int userId, Integer bookingId, Integer flightId) {
        String sqlWithBooking = """
                SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
                       f.status, b.booking_id, b.booking_ref, b.class AS booking_class,
                       al.airline_name,
                       oa.iata_code AS origin_code, oa.city AS origin_city,
                       da.iata_code AS dest_code, da.city AS dest_city
                FROM bookings b
                JOIN flights f ON f.flight_id = b.flight_id
                JOIN airlines al ON al.airline_id = f.airline_id
                JOIN airports oa ON oa.airport_id = f.origin_airport_id
                JOIN airports da ON da.airport_id = f.dest_airport_id
                WHERE b.booking_id = ?
                  AND b.user_id = ?
                """;
        String sqlWithFlight = """
                SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
                       f.status, NULL AS booking_id, NULL AS booking_ref, NULL AS booking_class,
                       al.airline_name,
                       oa.iata_code AS origin_code, oa.city AS origin_city,
                       da.iata_code AS dest_code, da.city AS dest_city
                FROM flights f
                JOIN airlines al ON al.airline_id = f.airline_id
                JOIN airports oa ON oa.airport_id = f.origin_airport_id
                JOIN airports da ON da.airport_id = f.dest_airport_id
                WHERE f.flight_id = ?
                """;

        try (Connection conn = DBConnection.getConnection()) {
            if (bookingId != null) {
                try (PreparedStatement ps = conn.prepareStatement(sqlWithBooking)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return rowToMap(rs);
                        }
                    }
                }
            }

            if (flightId != null) {
                try (PreparedStatement ps = conn.prepareStatement(sqlWithFlight)) {
                    ps.setInt(1, flightId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return rowToMap(rs);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[SeatSelectionServlet] findFlight error: " + e.getMessage());
        }

        return null;
    }

    private SeatPageData loadSeatPageData(int flightId, Integer bookingId, int passengerId) {
        SeatPageData data = new SeatPageData();
        data.seats = findSeats(flightId, bookingId, passengerId);
        data.selectedSeats = findSelectedSeats(flightId, bookingId, passengerId);

        if (data.seats == null) {
            data.seats = new ArrayList<>();
            data.errorMessage = "Seat selection table is not ready. Please import SeatSelection.sql after Airline.sql.";
        }

        return data;
    }

    private List<Map<String, Object>> findSeats(int flightId, Integer bookingId, int passengerId) {
        String sql = """
                SELECT s.seat_id, s.seat_number, s.class,
                       COALESCE(fsa.is_available, 1) AS is_available,
                       CASE WHEN selected.selected_seat_id IS NULL THEN 0 ELSE 1 END AS is_booked,
                       CASE WHEN own.selected_seat_id IS NULL THEN 0 ELSE 1 END AS is_selected
                FROM flights f
                JOIN seats s ON s.aircraft_id = f.aircraft_id
                LEFT JOIN flight_seat_availability fsa
                       ON fsa.flight_id = f.flight_id
                      AND fsa.seat_id = s.seat_id
                LEFT JOIN selected_seats selected
                       ON selected.flight_id = f.flight_id
                      AND selected.seat_id = s.seat_id
                LEFT JOIN selected_seats own
                       ON own.flight_id = f.flight_id
                      AND own.seat_id = s.seat_id
                      AND own.passenger_id = ?
                      AND (? IS NULL OR own.booking_id = ?)
                WHERE f.flight_id = ?
                ORDER BY s.class, s.seat_number
                """;
        List<Map<String, Object>> seats = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
            if (bookingId == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
                ps.setNull(3, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, bookingId);
                ps.setInt(3, bookingId);
            }
            ps.setInt(4, flightId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    seats.add(rowToMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[SeatSelectionServlet] findSeats error: " + e.getMessage());
            if (e.getMessage() != null && e.getMessage().contains("selected_seats")) {
                return null;
            }
        }

        return seats;
    }

    private List<Map<String, Object>> findSelectedSeats(int flightId, Integer bookingId, int passengerId) {
        List<Map<String, Object>> selectedSeats = new ArrayList<>();
        if (bookingId == null) {
            return selectedSeats;
        }

        String sql = """
                SELECT ss.selected_seat_id, ss.booking_id, ss.passenger_id,
                       s.seat_id, s.seat_number, s.class, ss.selected_at
                FROM selected_seats ss
                JOIN seats s ON s.seat_id = ss.seat_id
                WHERE ss.flight_id = ?
                  AND ss.booking_id = ?
                  AND ss.passenger_id = ?
                ORDER BY s.seat_number
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, flightId);
            ps.setInt(2, bookingId);
            ps.setInt(3, passengerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    selectedSeats.add(rowToMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[SeatSelectionServlet] findSelectedSeats error: " + e.getMessage());
        }

        return selectedSeats;
    }

    private boolean saveSelectedSeats(int passengerId, int bookingId, int flightId, List<Integer> seatIds) {
        ensureMultipleSeatsPerBookingAllowed();

        String validateBooking = "SELECT booking_id FROM bookings WHERE booking_id = ? AND user_id = ? AND flight_id = ?";
        String validateSeat = """
                SELECT s.seat_id
                FROM flights f
                JOIN seats s ON s.aircraft_id = f.aircraft_id
                LEFT JOIN flight_seat_availability fsa
                       ON fsa.flight_id = f.flight_id
                      AND fsa.seat_id = s.seat_id
                LEFT JOIN selected_seats ss
                       ON ss.flight_id = f.flight_id
                      AND ss.seat_id = s.seat_id
                      AND NOT (ss.booking_id = ? AND ss.passenger_id = ?)
                LEFT JOIN selected_seats own
                       ON own.flight_id = f.flight_id
                      AND own.seat_id = s.seat_id
                      AND own.booking_id = ?
                      AND own.passenger_id = ?
                WHERE f.flight_id = ?
                  AND s.seat_id = ?
                  AND (COALESCE(fsa.is_available, 1) = 1 OR own.selected_seat_id IS NOT NULL)
                  AND ss.selected_seat_id IS NULL
                """;
        String oldSeats = "SELECT seat_id FROM selected_seats WHERE booking_id = ? AND passenger_id = ?";
        String deleteOld = "DELETE FROM selected_seats WHERE booking_id = ? AND passenger_id = ?";
        String releaseSeat = """
                UPDATE flight_seat_availability
                SET is_available = 1
                WHERE flight_id = ?
                  AND seat_id = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM selected_seats
                      WHERE flight_id = ?
                        AND seat_id = ?
                  )
                """;
        String insertSelected = """
                INSERT INTO selected_seats (booking_id, passenger_id, flight_id, seat_id)
                VALUES (?, ?, ?, ?)
                """;
        String holdAvailability = """
                INSERT INTO flight_seat_availability (flight_id, seat_id, is_available)
                VALUES (?, ?, 0)
                ON DUPLICATE KEY UPDATE is_available = 0
                """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                if (!exists(conn, validateBooking, bookingId, passengerId, flightId)) {
                    conn.rollback();
                    return false;
                }

                for (Integer seatId : seatIds) {
                    if (!exists(conn, validateSeat, bookingId, passengerId, bookingId, passengerId, flightId, seatId)) {
                        conn.rollback();
                        return false;
                    }
                }

                List<Integer> previousSeatIds = findPreviousSeats(conn, oldSeats, bookingId, passengerId);

                try (PreparedStatement ps = conn.prepareStatement(deleteOld)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, passengerId);
                    ps.executeUpdate();
                }

                for (Integer previousSeatId : previousSeatIds) {
                    try (PreparedStatement ps = conn.prepareStatement(releaseSeat)) {
                        ps.setInt(1, flightId);
                        ps.setInt(2, previousSeatId);
                        ps.setInt(3, flightId);
                        ps.setInt(4, previousSeatId);
                        ps.executeUpdate();
                    }
                }

                for (Integer seatId : seatIds) {
                    try (PreparedStatement ps = conn.prepareStatement(insertSelected)) {
                        ps.setInt(1, bookingId);
                        ps.setInt(2, passengerId);
                        ps.setInt(3, flightId);
                        ps.setInt(4, seatId);
                        ps.executeUpdate();
                    }

                    try (PreparedStatement ps = conn.prepareStatement(holdAvailability)) {
                        ps.setInt(1, flightId);
                        ps.setInt(2, seatId);
                        ps.executeUpdate();
                    }
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("[SeatSelectionServlet] saveSelectedSeats error: " + e.getMessage());
            return false;
        }
    }

    private void ensureMultipleSeatsPerBookingAllowed() {
        String sql = "ALTER TABLE selected_seats DROP INDEX uq_selected_seat_booking_passenger";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            String message = e.getMessage() == null ? "" : e.getMessage().toLowerCase();
            if (!message.contains("check that column/key exists")
                    && !message.contains("can't drop")
                    && !message.contains("doesn't exist")) {
                System.err.println("[SeatSelectionServlet] ensureMultipleSeatsPerBookingAllowed error: " + e.getMessage());
            }
        }
    }

    private boolean exists(Connection conn, String sql, int... values) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < values.length; i++) {
                ps.setInt(i + 1, values[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private List<Integer> findPreviousSeats(Connection conn, String sql, int bookingId, int passengerId)
            throws SQLException {
        List<Integer> seatIds = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, passengerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    seatIds.add(rs.getInt("seat_id"));
                }
            }
        }

        return seatIds;
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response,
                              Integer bookingId, Integer flightId, String message, String next)
            throws IOException {
        StringBuilder target = new StringBuilder(request.getContextPath()).append("/seat-selection?");
        if (bookingId != null) {
            target.append("bookingId=").append(bookingId).append("&");
        }
        if (flightId != null) {
            target.append("flightId=").append(flightId).append("&");
        }
        if (next != null && !next.trim().isEmpty()) {
            target.append("next=").append(URLEncoder.encode(next.trim(), StandardCharsets.UTF_8)).append("&");
        }
        target.append("error=").append(URLEncoder.encode(message, StandardCharsets.UTF_8));
        response.sendRedirect(target.toString());
    }

    private Integer parseInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private List<Integer> parseIntValues(String[] values) {
        List<Integer> parsedValues = new ArrayList<>();
        if (values == null) {
            return parsedValues;
        }

        for (String value : values) {
            Integer parsedValue = parseInt(value);
            if (parsedValue != null && !parsedValues.contains(parsedValue)) {
                parsedValues.add(parsedValue);
            }
        }

        return parsedValues;
    }

    private Map<String, Object> rowToMap(ResultSet rs) throws SQLException {
        Map<String, Object> row = new LinkedHashMap<>();
        ResultSetMetaData meta = rs.getMetaData();

        for (int i = 1; i <= meta.getColumnCount(); i++) {
            row.put(meta.getColumnLabel(i).toLowerCase(), rs.getObject(i));
        }

        return row;
    }

    private static class SeatPageData {
        private List<Map<String, Object>> seats;
        private List<Map<String, Object>> selectedSeats;
        private String errorMessage;
    }
}
