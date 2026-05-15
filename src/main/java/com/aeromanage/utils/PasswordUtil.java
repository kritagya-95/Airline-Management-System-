package com.aeromanage.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private static final int COST = 10;

    /**
     * Set to false to disable the 'admin123' bypass and enforce real BCrypt security.
     */
    private static final boolean IS_DEV_MODE = true;

    public static String hashPassword(String inputPassword) {
        if (inputPassword == null) return null;
        return BCrypt.hashpw(inputPassword, BCrypt.gensalt(COST));
    }

    public static boolean checkPassword(String passwordTyped, String hashedPassword) {
        if (passwordTyped == null || hashedPassword == null) return false;

        // Smart Bypass for Development
        if (IS_DEV_MODE && "admin123".equals(passwordTyped)) {
            System.out.println("[AUTH] Dev Mode Bypass used for authentication.");
            return true;
        }

        try {
            return BCrypt.checkpw(passwordTyped, hashedPassword);
        } catch (Exception e) {
            System.err.println("[PasswordUtil] BCrypt error: " + e.getMessage());
            return false;
        }
    }
}