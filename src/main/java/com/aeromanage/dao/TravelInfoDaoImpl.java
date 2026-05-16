package com.aeromanage.dao;

import com.aeromanage.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TravelInfoDaoImpl implements TravelInfoDao {

    @Override
    public List<Map<String, Object>> getPopularRoutes() {
        String sql = """
            SELECT
                oa.city AS origin_city,
                oa.iata_code AS origin_code,
                da.city AS dest_city,
                da.iata_code AS dest_code,
                COUNT(f.flight_id) AS flight_count,
                MIN(f.base_economy_fare) AS starting_fare
            FROM flights f
            JOIN airports oa ON oa.airport_id = f.origin_airport_id
            JOIN airports da ON da.airport_id = f.dest_airport_id
            WHERE f.status IN ('SCHEDULED', 'BOARDING')
            GROUP BY oa.city, oa.iata_code, da.city, da.iata_code
            ORDER BY flight_count DESC, starting_fare ASC
            """;
        return fetchMaps(sql);
    }

    @Override
    public List<Map<String, Object>> getPartnerAirlines() {
        String sql = """
            SELECT airline_name, iata_code, country, logo_url
            FROM airlines
            ORDER BY airline_name ASC
            """;
        return fetchMaps(sql);
    }

    private List<Map<String, Object>> fetchMaps(String sql) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rowToMap(rs));
            }
        } catch (SQLException e) {
            System.err.println("[TravelInfoDaoImpl] fetchMaps error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    private Map<String, Object> rowToMap(ResultSet rs) throws SQLException {
        Map<String, Object> map = new LinkedHashMap<>();
        ResultSetMetaData meta = rs.getMetaData();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
            map.put(meta.getColumnLabel(i).toLowerCase(), rs.getObject(i));
        }
        return map;
    }
}