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

@WebServlet("/profile/update")
@MultipartConfig
public class ProfileUpdateServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) SessionUtil.getAttribute(request, "user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String email     = request.getParameter("email");
        String phone     = request.getParameter("phone");
        Part imagePart   = request.getPart("profileImage");

        if (firstName == null || firstName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            request.setAttribute("errorMsg", "First name and email are required.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        String fullName = firstName.trim();
        if (lastName != null && !lastName.trim().isEmpty()) {
            fullName += " " + lastName.trim();
        }

        user.setFullName(fullName);
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");

        boolean updated = userDao.update(user);

        // ==================== IMAGE UPLOAD ====================
        if (imagePart != null && imagePart.getSize() > 0) {
            String newImageName = ImageUtil.uploadImage(imagePart);
            if (newImageName != null) {
                ImageUtil.deleteImage(user.getProfileImage());
                userDao.updateProfileImage(user.getUserId(), newImageName);
                user.setProfileImage(newImageName);
            }
        }

        if (updated) {
            SessionUtil.setAttribute(request, "user", user);
            request.getSession().setAttribute("profileUpdateSuccess", true);
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("errorMsg", "Profile update failed.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }
}