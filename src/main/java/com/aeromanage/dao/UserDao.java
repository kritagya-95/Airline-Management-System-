package com.aeromanage.dao;

import com.aeromanage.entity.User;

/**
 * Data access interface defining persistence operations for the {@link User} entity.
 *
 * <p>Implementations of this interface are responsible for all database communication
 * related to user account management including retrieval, persistence, and mutation
 * of user records. Staff record initialisation is also delegated through this interface
 * to maintain separation of concerns at the controller layer.</p>
 *
 * @see User
 */
public interface UserDao {

    /**
     * Retrieves a user record by email address.
     *
     * @param email the email address to search for
     * @return the matching {@link User} entity, or {@code null} if not found
     */
    User findByEmail(String email);

    /**
     * Persists a new user record and populates the generated primary key
     * on the provided entity.
     *
     * @param user the {@link User} entity to persist
     * @return {@code true} if the record was successfully inserted, {@code false} otherwise
     */
    boolean save(User user);

    /**
     * Retrieves a user record by primary key.
     *
     * @param userId the unique identifier of the user
     * @return the matching {@link User} entity, or {@code null} if not found
     */
    User findById(int userId);

    /**
     * Updates an existing user record with the current state of the provided entity.
     *
     * @param user the {@link User} entity containing updated field values
     * @return {@code true} if the record was successfully updated, {@code false} otherwise
     */
    boolean update(User user);

    /**
     * Updates the stored password hash for the given user.
     *
     * @param userId the unique identifier of the user
     * @param hashedPassword the new BCrypt password hash
     * @return {@code true} if the password was successfully updated, {@code false} otherwise
     */
    boolean updatePassword(int userId, String hashedPassword);

    /**
     * Deletes a passenger account and dependent booking data.
     *
     * @param userId the unique identifier of the passenger user
     * @return {@code true} if the account was successfully deleted, {@code false} otherwise
     */
    boolean deletePassengerAccount(int userId);

    /**
     * Creates an initial staff profile record associated with the given user identifier.
     *
     * <p>Invoked automatically following successful staff account registration to
     * initialise the corresponding entry in the {@code staff} table with default
     * operational values.</p>
     *
     * @param userId the primary key of the newly registered staff user
     */
    void saveStaffRecord(int userId);
}
