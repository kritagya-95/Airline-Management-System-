package com.aeromanage.dao;

import java.util.List;
import java.util.Map;

/**
 * StaffDao — Data access for Staff Dashboard
 */
public interface StaffDao {

    int countPassengersToday();
    int countTodayFlights();

    List<Map<String, Object>> getTodayFlights();

    Map<String, Object> findBookingByReference(String bookingRef);

    boolean updateFlightStatus(int flightId, String newStatus, int staffUserId, String reason);
}