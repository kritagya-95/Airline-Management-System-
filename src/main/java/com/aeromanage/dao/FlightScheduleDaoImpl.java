package com.aeromanage.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Add 'implements FlightScheduleDao' here to anchor it structurally!
public class FlightScheduleDaoImpl implements FlightScheduleDao {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/skyline_airlines?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override // Add the override annotation
    public List<Map<String, Object>> searchPublicSchedules(String origin, String dest) {
        List<Map<String, Object>> flightList = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT flight_id, flight_number, airline_name, origin_code, origin_city, " +
                        "dest_code, dest_city, departure_time, arrival_time, duration, " +
                        "status, base_economy_fare, base_business_fare FROM v_flight_search WHERE 1=1 "
        );

        boolean hasFilters = (origin != null && !origin.trim().isEmpty()) && (dest != null && !dest.trim().isEmpty());
        if (hasFilters) {
            sql.append("AND (origin_city LIKE ? OR origin_code = ?) AND (dest_city LIKE ? OR dest_code = ?) ");
        }
        sql.append("ORDER BY departure_time ASC");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(sql.toString())) {

                if (hasFilters) {
                    String origParam = "%" + origin.trim() + "%";
                    String destParam = "%" + dest.trim() + "%";
                    ps.setString(1, origParam);
                    ps.setString(2, origin.trim().toUpperCase());
                    ps.setString(3, destParam);
                    ps.setString(4, dest.trim().toUpperCase());
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> flight = new HashMap<>();
                        flight.put("flight_id", rs.getInt("flight_id"));
                        flight.put("flight_number", rs.getString("flight_number"));
                        flight.put("airline_name", rs.getString("airline_name"));
                        flight.put("origin_code", rs.getString("origin_code"));
                        flight.put("origin_city", rs.getString("origin_city"));
                        flight.put("dest_code", rs.getString("dest_code"));
                        flight.put("dest_city", rs.getString("dest_city"));
                        flight.put("departure_time", rs.getTimestamp("departure_time"));
                        flight.put("arrival_time", rs.getTimestamp("arrival_time"));
                        flight.put("duration", rs.getString("duration"));
                        flight.put("status", rs.getString("status"));
                        flight.put("base_economy_fare", rs.getBigDecimal("base_economy_fare"));
                        flight.put("base_business_fare", rs.getBigDecimal("base_business_fare"));
                        flightList.add(flight);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flightList;
    }
}