package com.aeromanage.controller;

import com.aeromanage.dao.TravelInfoDao;
import com.aeromanage.dao.TravelInfoDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/partner-airlines")
public class PartnerAirlinesServlet extends HttpServlet {

    private final TravelInfoDao travelInfoDao = new TravelInfoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("airlines", travelInfoDao.getPartnerAirlines());
        request.getRequestDispatcher("/WEB-INF/views/partner-airlines.jsp")
                .forward(request, response);
    }
}
