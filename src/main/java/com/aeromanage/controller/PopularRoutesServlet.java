package com.aeromanage.controller;

import com.aeromanage.dao.TravelInfoDao;
import com.aeromanage.dao.TravelInfoDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/popular-routes")
public class PopularRoutesServlet extends HttpServlet {

    private final TravelInfoDao travelInfoDao = new TravelInfoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("routes", travelInfoDao.getPopularRoutes());
        request.getRequestDispatcher("/WEB-INF/views/popular-routes.jsp")
                .forward(request, response);
    }
}
