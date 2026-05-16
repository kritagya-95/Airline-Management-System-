package com.aeromanage.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

/**
 * Serves images from external ~/skyline-uploads/ folder
 */
@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String filename = request.getPathInfo();
        if (filename == null || filename.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        filename = filename.substring(1); // remove leading slash

        String uploadPath = System.getProperty("user.home") + File.separator + "skyline-uploads";
        File file = new File(uploadPath, filename);

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Security check
        if (!file.getCanonicalPath().startsWith(new File(uploadPath).getCanonicalPath())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String contentType = Files.probeContentType(file.toPath());
        if (contentType != null) {
            response.setContentType(contentType);
        }

        response.setContentLengthLong(file.length());

        try (OutputStream out = response.getOutputStream()) {
            Files.copy(file.toPath(), out);
        }
    }
}