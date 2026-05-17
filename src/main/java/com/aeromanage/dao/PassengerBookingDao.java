package com.aeromanage.dao;

import java.util.List;
import java.util.Map;

public interface PassengerBookingDao {
    List<Map<String, Object>> getCurrentBookings(int userId);
    List<Map<String, Object>> getRecentBookings(int userId);
    List<Map<String, Object>> getPastBookings(int userId);
    List<Map<String, Object>> getCancelledBookings(int userId);
    boolean cancelBooking(int userId, int bookingId, String reason);
    boolean createBooking(int userId, int flightId, String ticketClass, double totalFare);
}