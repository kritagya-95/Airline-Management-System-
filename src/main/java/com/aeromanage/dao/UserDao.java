package com.aeromanage.dao;

import com.aeromanage.entity.User;

/**
 * UserDao Interface - Defines data access methods for User
 */
public interface UserDao {

    User findByEmail(String email);

    boolean save(User user);

    // You can add more methods later (findById, update, etc.)
}