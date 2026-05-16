package com.aeromanage.utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;

public class ImageUtil {

    public static String uploadImage(Part imagePart) {
        if (imagePart == null || imagePart.getSubmittedFileName() == null ||
                imagePart.getSubmittedFileName().isEmpty()) {
            System.out.println("[ImageUtil] No file received");
            return null;
        }

        String fileName = imagePart.getSubmittedFileName();
        String extension = "";

        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex != -1) {
            extension = fileName.substring(dotIndex).toLowerCase();
        }

        if (!".jpg".equals(extension) && !".jpeg".equals(extension) && !".png".equals(extension)) {
            System.out.println("[ImageUtil] Invalid extension: " + extension);
            return null;
        }

        String uniqueName = LocalDateTime.now().toString()
                .replace(":", "-").replace("T", "_") + extension;

        // Save to deployed webapp/uploads (Cargo compatible)
        String uploadDirPath = System.getProperty("catalina.base") +
                "/webapps/ROOT/uploads";

        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            System.out.println("[ImageUtil] Created directory: " + uploadDirPath);
        }

        try {
            String fullPath = uploadDir + File.separator + uniqueName;
            imagePart.write(fullPath);
            System.out.println("[ImageUtil] ✅ SUCCESS: Saved " + uniqueName);
            return uniqueName;
        } catch (IOException e) {
            System.err.println("[ImageUtil] ❌ FAILED: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static void deleteImage(String imageName) {
        if (imageName == null || imageName.isEmpty() || "default-avatar.png".equals(imageName)) {
            return;
        }
        String path = System.getProperty("catalina.base") + "/webapps/ROOT/uploads/" + imageName;
        new File(path).delete();
    }
}