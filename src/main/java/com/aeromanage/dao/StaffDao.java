package com.aeromanage.dao;

import java.util.List;
import java.util.Map;

public interface StaffDao {

    // ── Existing ───────────────────────────────────────
    int countPassengersToday();
    int countTodayFlights();
    List<Map<String, Object>> getTodayFlights();
    Map<String, Object> findBookingByReference(String bookingRef);
    boolean updateFlightStatus(int flightId, String newStatus,
                               int staffUserId, String reason);

    // ── New ────────────────────────────────────────────
    List<Map<String, Object>> getAllFlights();
    List<Map<String, Object>> getFlightStatusHistory();
    List<Map<String, Object>> getAllPassengers();
    List<Map<String, Object>> getRecentBookings();
    List<Map<String, Object>> getCancelledBookings();
}