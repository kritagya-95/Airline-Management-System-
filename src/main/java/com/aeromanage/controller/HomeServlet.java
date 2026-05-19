package com.aeromanage.controller;

import com.aeromanage.dao.AdminDao;
import com.aeromanage.dao.AdminDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet controller responsible for rendering the primary home page of the application.
 *
 * <p>Accessible to both authenticated and unauthenticated users. Retrieves the current
 * flight inventory from the persistence layer for display in the popular flights section.</p>
 *
 * <p>Mapped to: {@code /home} and {@code ""}(the root context path)</p>
 */
// 🌟 FIXED: Added multiple value mappings so it triggers on both "/home" AND when someone visits the base root directory URL!
@WebServlet(value = {"/home", ""})
public class HomeServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user != null) {
            request.setAttribute("user", user);
        }

        // Show only 9 flights on Home Page
        List<Map<String, Object>> flights = adminDao.getLimitedFlights(9);
        request.setAttribute("flights", flights);

        System.out.println("[HomeServlet] Loaded " + flights.size() + " flights for home display.");

        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}