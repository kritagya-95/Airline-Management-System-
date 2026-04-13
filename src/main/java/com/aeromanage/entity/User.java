package com.aeromanage.entity;

/**
 * User Entity - Represents a user in SkyLine Airlines system
 */
public class User {

    private int userId;
    private String fullName;
    private String email;
    private String password;        // hashed password
    private String phone;
    private String role;            // ADMIN or PASSENGER
    private String status;          // PENDING, APPROVED, REJECTED

    // Default constructor
    public User() {}

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}