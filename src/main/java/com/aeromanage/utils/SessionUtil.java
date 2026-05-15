package com.aeromanage.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class providing centralised HTTP session management for the
 * SkyLine Airlines application.
 *
 * <p>Abstracts common session operations including attribute storage and retrieval,
 * session timeout configuration, and session invalidation on logout. Centralising
 * these operations ensures consistent session behaviour across all servlet controllers.</p>
 *
 * <p>Sessions are configured with a maximum inactive interval of 30 minutes.
 * Attribute retrieval is performed against existing sessions only to avoid
 * unintentional session creation.</p>
 *
 * <p>This class is not instantiable.</p>
 */
public class SessionUtil {

    private static final int SESSION_TIMEOUT_SECONDS = 30 * 60;

    private SessionUtil() {}

    /**
     * Stores the specified attribute in the current HTTP session, creating the
     * session if one does not already exist. Resets the session timeout to
     * the configured maximum inactive interval on each invocation.
     *
     * @param request the current {@link HttpServletRequest}
     * @param key     the attribute name under which the value is stored
     * @param value   the attribute value to store in the session
     */
    public static void setAttribute(HttpServletRequest request, String key, Object value) {
        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);
        session.setAttribute(key, value);
    }

    /**
     * Retrieves the specified attribute from the existing HTTP session.
     *
     * <p>Returns {@code null} if no active session exists or if the requested
     * attribute is not present in the session scope.</p>
     *
     * @param request the current {@link HttpServletRequest}
     * @param key     the attribute name to retrieve
     * @return the attribute value, or {@code null} if not found
     */
    public static Object getAttribute(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false);
        return (session != null) ? session.getAttribute(key) : null;
    }

    /**
     * Invalidates the current HTTP session if one exists, effectively terminating
     * the authenticated user session and clearing all session-scoped attributes.
     *
     * @param request the current {@link HttpServletRequest}
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}