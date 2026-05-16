package com.aeromanage.entity;

import java.time.LocalDateTime;

/**
 * Entity class representing a registered user within the SkyLine Airlines system.
 *
 * <p>Encapsulates all user account attributes including personal details, credentials,
 * role assignment, approval status, and auditing timestamps. Instances of this class
 * serve as the primary data transfer object between the persistence layer and the
 * servlet controller layer throughout the application.</p>
 *
 * <p>Roles: {@code ADMIN}, {@code STAFF}, {@code PASSENGER}</p>
 * <p>Statuses: {@code PENDING}, {@code APPROVED}, {@code REJECTED}</p>
 */
public class User {

    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String role;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String profileImage = "default-avatar.png";

    // NEW Getter & Setter for Profile Image
    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) {
        this.profileImage = (profileImage != null) ? profileImage : "default-avatar.png";
    }
    /**
     * Default no-argument constructor required for JavaBean compliance
     * and framework instantiation.
     */
    public User() {}

    /**
     * Returns the unique system identifier for this user.
     *
     * @return the user ID
     */
    public int getUserId() { return userId; }

    /**
     * Sets the unique system identifier for this user.
     *
     * @param userId the user ID to assign
     */
    public void setUserId(int userId) { this.userId = userId; }

    /**
     * Returns the full display name of this user.
     *
     * @return the full name
     */
    public String getFullName() { return fullName; }

    /**
     * Sets the full display name of this user.
     *
     * @param fullName the full name to assign
     */
    public void setFullName(String fullName) { this.fullName = fullName; }

    /**
     * Returns the email address associated with this user account.
     *
     * @return the email address
     */
    public String getEmail() { return email; }

    /**
     * Sets the email address for this user account.
     *
     * @param email the email address to assign
     */
    public void setEmail(String email) { this.email = email; }

    /**
     * Returns the BCrypt-hashed password for this user account.
     *
     * @return the hashed password string
     */
    public String getPassword() { return password; }

    /**
     * Sets the BCrypt-hashed password for this user account.
     *
     * @param password the hashed password string to assign
     */
    public void setPassword(String password) { this.password = password; }

    /**
     * Returns the contact phone number for this user.
     *
     * @return the phone number
     */
    public String getPhone() { return phone; }

    /**
     * Sets the contact phone number for this user.
     *
     * @param phone the phone number to assign
     */
    public void setPhone(String phone) { this.phone = phone; }

    /**
     * Returns the assigned role for this user.
     *
     * @return one of {@code ADMIN}, {@code STAFF}, or {@code PASSENGER}
     */
    public String getRole() { return role; }

    /**
     * Sets the assigned role for this user.
     *
     * @param role one of {@code ADMIN}, {@code STAFF}, or {@code PASSENGER}
     */
    public void setRole(String role) { this.role = role; }

    /**
     * Returns the current approval status of this user account.
     *
     * @return one of {@code PENDING}, {@code APPROVED}, or {@code REJECTED}
     */
    public String getStatus() { return status; }

    /**
     * Sets the approval status of this user account.
     *
     * @param status one of {@code PENDING}, {@code APPROVED}, or {@code REJECTED}
     */
    public void setStatus(String status) { this.status = status; }

    /**
     * Returns the timestamp at which this user account was created.
     *
     * @return the creation timestamp as {@link LocalDateTime}
     */
    public LocalDateTime getCreatedAt() { return createdAt; }

    /**
     * Sets the creation timestamp for this user account.
     *
     * @param createdAt the creation timestamp to assign
     */
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    /**
     * Returns the timestamp of the most recent update to this user account.
     *
     * @return the last updated timestamp as {@link LocalDateTime}
     */
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    /**
     * Sets the last updated timestamp for this user account.
     *
     * @param updatedAt the last updated timestamp to assign
     */
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }


    /**
     * Returns a string representation of this user for diagnostic and logging purposes.
     *
     * @return a formatted string containing the user ID, full name, role, and status
     */
    @Override
    public String toString() {
        return "User{userId=" + userId
                + ", fullName='" + fullName + '\''
                + ", role='" + role + '\''
                + ", status='" + status + '\''
                + "}";
    }
}