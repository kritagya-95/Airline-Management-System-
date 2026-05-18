package com.aeromanage.controller.admin;

import com.aeromanage.dao.AdminDao;
import com.aeromanage.dao.AdminDaoImpl;
import com.aeromanage.utils.ImageUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/admin/flights")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class AdminFlightServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String imageName = null;
        Part imagePart = request.getPart("flightImage");
        if (imagePart != null && imagePart.getSize() > 0) {
            imageName = ImageUtil.uploadImage(imagePart);
        }

        boolean success;
        try {
            if ("update".equals(action)) {
                success = adminDao.updateFlight(
                        parseInt(request, "flightId"),
                        parseInt(request, "airlineId"),
                        parseInt(request, "aircraftId"),
                        request.getParameter("flightNumber"),
                        request.getParameter("originCode"),
                        request.getParameter("originCity"),
                        request.getParameter("originCountry"),
                        request.getParameter("destCode"),
                        request.getParameter("destCity"),
                        request.getParameter("destCountry"),
                        parseTimestamp(request, "departureTime"),
                        parseTimestamp(request, "arrivalTime"),
                        request.getParameter("status"),
                        parseDouble(request, "economyFare"),
                        parseDouble(request, "businessFare"),
                        imageName
                );
            } else {
                success = adminDao.addFlight(
                        parseInt(request, "airlineId"),
                        parseInt(request, "aircraftId"),
                        request.getParameter("flightNumber"),
                        request.getParameter("originCode"),
                        request.getParameter("originCity"),
                        request.getParameter("originCountry"),
                        request.getParameter("destCode"),
                        request.getParameter("destCity"),
                        request.getParameter("destCountry"),
                        parseTimestamp(request, "departureTime"),
                        parseTimestamp(request, "arrivalTime"),
                        request.getParameter("status"),
                        parseDouble(request, "economyFare"),
                        parseDouble(request, "businessFare"),
                        imageName
                );
            }
        } catch (RuntimeException e) {
            System.err.println("[AdminFlightServlet] validation error: " + e.getMessage());
            success = false;
        }

        String result = success ? "flightSaved" : "flightError";
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?" + result + "=true#section-flights");
    }

    private int parseInt(HttpServletRequest request, String name) {
        return Integer.parseInt(request.getParameter(name));
    }

    private double parseDouble(HttpServletRequest request, String name) {
        return Double.parseDouble(request.getParameter(name));
    }

    private Timestamp parseTimestamp(HttpServletRequest request, String name) {
        return Timestamp.valueOf(LocalDateTime.parse(request.getParameter(name)));
    }
}
