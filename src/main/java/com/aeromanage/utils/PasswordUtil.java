/**package com.aeromanage.utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * PasswordUtil — BCrypt password hashing for SkyLine Airlines.
 */
/**public class PasswordUtil {

    private static final int COST = 10;

    public static String hashPassword(String inputPassword) {
        String salt = BCrypt.gensalt(COST);
        return BCrypt.hashpw(inputPassword, salt);
    }

    public static boolean checkPassword(String passwordTyped, String hashedPassword) {
        return BCrypt.checkpw(passwordTyped, hashedPassword);
    }
}*/