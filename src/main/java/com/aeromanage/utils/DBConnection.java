package com.aeromanage.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class providing centralised JDBC connection management for the SkyLine
 * Airlines application.
 *
 * <p>Encapsulates MySQL driver registration and connection acquisition via
 * {@link DriverManager}. All database access throughout the application is routed
 * through this class to ensure consistent connection configuration.</p>
 *
 * <p>This implementation uses a simple single-connection-per-request strategy.
 * For high-concurrency production deployments, replacement with a connection
 * pooling solution such as HikariCP or Apache DBCP is recommended.</p>
 */
public class DBConnection {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/skyline_airlines?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    /**
     * Acquires and returns a new {@link Connection} to the configured MySQL database.
     *
     * @return an active {@link Connection} instance
     * @throws SQLException if a database access error occurs or the connection
     *                      cannot be established
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Safely closes the provided {@link Connection} instance if it is not {@code null}.
     *
     * <p>Intended for use in {@code finally} blocks where try-with-resources is not
     * applicable. Exceptions encountered during closure are logged to standard output.</p>
     *
     * @param connection the {@link Connection} to close, may be {@code null}
     */
    public static void closeConnection(Connection connection) {
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
}