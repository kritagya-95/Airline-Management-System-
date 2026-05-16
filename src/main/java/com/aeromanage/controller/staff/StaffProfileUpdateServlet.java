package com.aeromanage.controller;

import com.aeromanage.dao.UserDao;
import com.aeromanage.dao.UserDaoImpl;
import com.aeromanage.entity.User;
import com.aeromanage.utils.ImageUtil;
import com.aeromanage.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;

@WebServlet("/staff/profile/update")
@MultipartConfig
public class StaffProfileUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user == null || !"STAFF".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        Part imagePart  = request.getPart("profileImage");

        if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            request.setAttribute("errorMsg", "Full name and email are required.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/staff-profile.jsp").forward(request, response);
            return;
        }

        // Update basic info
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");

        boolean updated = userDao.update(user);

        // Handle Profile Image Upload
        if (imagePart != null && imagePart.getSize() > 0) {
            String newImageName = ImageUtil.uploadImage(imagePart);
            if (newImageName != null) {
                // Delete old image if exists
                ImageUtil.deleteImage(user.getProfileImage());
                // Update database with new image
                userDao.updateProfileImage(user.getUserId(), newImageName);
                user.setProfileImage(newImageName);
            }
        }

        if (updated) {
            SessionUtil.setAttribute(request, "user", user);
            request.getSession().setAttribute("profileUpdateSuccess", true);
            response.sendRedirect(request.getContextPath() + "/staff/profile");
        } else {
            request.setAttribute("errorMsg", "Profile update failed. Please try again.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/staff-profile.jsp").forward(request, response);
        }
    }
}