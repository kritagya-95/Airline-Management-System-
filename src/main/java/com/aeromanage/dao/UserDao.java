package com.aeromanage.dao;

import com.aeromanage.entity.User;

/**
 * UserDao Interface - Defines data access methods for User
 */
public interface UserDao {

    User findByEmail(String email);

    boolean save(User user);

    User findById(int userId);

    boolean update(User user);
}