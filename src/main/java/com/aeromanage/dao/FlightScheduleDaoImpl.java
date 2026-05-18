package com.aeromanage.dao;

// 1. IMPORT the exact same connection utility class your HomeServlet uses!
import com.aeromanage.utils.DBConnection; // <-- Adjust this package path to match your project

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FlightScheduleDaoImpl implements FlightScheduleDao {

    @Override
    public List<Map<String, Object>> searchPublicSchedules(String origin, String dest) {
        List<Map<String, Object>> flightList = new ArrayList<>();

        String sql = "SELECT flight_id, flight_number, airline_name, origin_code, origin_city, " +
                "dest_code, dest_city, departure_time, arrival_time, duration, " +
                "status, base_economy_fare, base_business_fare " +
                "FROM v_flight_search " +
                "ORDER BY origin_city ASC, departure_time ASC";

        try {
            // 2. USE the exact connection method that your HomeServlet uses successfully!
            try (Connection conn = DBConnection.getConnection(); // <-- This bypasses hardcoded passwords entirely
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                System.out.println("[DAO] Connection established successfully using project DB utility.");

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

                System.out.println("[DAO] Done! Total schedules packed into list: " + flightList.size());
            }
        } catch (Exception e) {
            System.err.println("[DAO] CRITICAL ERROR: Database execution completely dropped out!");
            e.printStackTrace();
        }
        return flightList;
    }
}