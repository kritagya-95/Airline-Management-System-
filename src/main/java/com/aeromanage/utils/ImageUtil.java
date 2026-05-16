package com.aeromanage.utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;

/**
 * Utility class for handling image file uploads.
 * Files are stored outside the project in ~/skyline-uploads/
 */
public class ImageUtil {

    private static final String UPLOAD_DIR = System.getProperty("user.home")
            + File.separator + "skyline-uploads";

    public static String uploadImage(Part imagePart) {
        if (imagePart == null || imagePart.getSubmittedFileName() == null ||
                imagePart.getSubmittedFileName().isEmpty()) {
            return null;
        }

        String fileName = imagePart.getSubmittedFileName();
        String extension = "";

        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex != -1) {
            extension = fileName.substring(dotIndex).toLowerCase();
        }

        if (!".jpg".equals(extension) && !".jpeg".equals(extension) && !".png".equals(extension)) {
            return null;
        }

        String uniqueName = LocalDateTime.now().toString()
                .replace(":", "-").replace("T", "_") + extension;

        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            imagePart.write(UPLOAD_DIR + File.separator + uniqueName);
            System.out.println("[ImageUtil] SUCCESS: " + uniqueName);
            return uniqueName;
        } catch (IOException e) {
            System.err.println("[ImageUtil] FAILED: " + e.getMessage());
            return null;
        }
    }

    public static void deleteImage(String imageName) {
        if (imageName == null || imageName.isEmpty() || "default-avatar.png".equals(imageName)) {
            return;
        }
        File file = new File(UPLOAD_DIR + File.separator + imageName);
        if (file.exists()) {
            file.delete();
        }
    }
}