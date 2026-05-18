USE skyline_airlines;

-- =============================================
-- SELECTED_SEATS TABLE (Fixed for Multiple Seats)
-- =============================================

CREATE TABLE IF NOT EXISTS selected_seats (
                                              selected_seat_id INT AUTO_INCREMENT PRIMARY KEY,
                                              booking_id       INT NOT NULL,
                                              passenger_id     INT NOT NULL,
                                              flight_id        INT NOT NULL,
                                              seat_id          INT NOT NULL,
                                              selected_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

                                              UNIQUE KEY uq_selected_seat_flight (flight_id, seat_id),     -- Only this should be unique
    KEY idx_selected_seat_booking (booking_id),
    KEY idx_selected_seat_passenger (passenger_id),

    CONSTRAINT fk_selected_seat_booking
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_passenger
    FOREIGN KEY (passenger_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_flight
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_seat
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id) ON DELETE CASCADE
    );

-- =============================================
-- FIX: Remove old blocking unique constraint
-- =============================================

ALTER TABLE selected_seats
DROP FOREIGN KEY IF EXISTS fk_selected_seat_booking;

ALTER TABLE selected_seats
DROP FOREIGN KEY IF EXISTS fk_selected_seat_passenger;

ALTER TABLE selected_seats
DROP INDEX IF EXISTS uq_selected_seat_booking_passenger;

ALTER TABLE selected_seats
DROP INDEX IF EXISTS uq_selected_seat_booking;

-- Re-add foreign keys cleanly
ALTER TABLE selected_seats
    ADD CONSTRAINT fk_selected_seat_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE;

ALTER TABLE selected_seats
    ADD CONSTRAINT fk_selected_seat_passenger
        FOREIGN KEY (passenger_id) REFERENCES users(user_id) ON DELETE CASCADE;

-- Make sure correct unique key exists
ALTER TABLE selected_seats
    ADD UNIQUE KEY IF NOT EXISTS uq_selected_seat_flight (flight_id, seat_id);

-- =============================================
-- INSERT SEAT DATA FOR AIRCRAFTS
-- =============================================

-- Preserve existing seats for aircraft 1
INSERT IGNORE INTO seats (aircraft_id, seat_number, class) VALUES
    (1, '1A', 'BUSINESS'), (1, '1B', 'BUSINESS'), (1, '1C', 'BUSINESS'),
    (1, '2A', 'BUSINESS'), (1, '2B', 'BUSINESS'), (1, '2C', 'BUSINESS'),
    (1, '10A', 'ECONOMY'), (1, '10B', 'ECONOMY'), (1, '10C', 'ECONOMY'),
    (1, '11A', 'ECONOMY'), (1, '11B', 'ECONOMY'), (1, '11C', 'ECONOMY'),
    (1, '12A', 'ECONOMY'), (1, '12B', 'ECONOMY'), (1, '12C', 'ECONOMY');

-- Add seats for other aircrafts
INSERT IGNORE INTO seats (aircraft_id, seat_number, class) VALUES
    (2, '1A', 'BUSINESS'), (2, '1B', 'BUSINESS'), (2, '1C', 'BUSINESS'), (2, '1D', 'BUSINESS'),
    (2, '2A', 'BUSINESS'), (2, '2B', 'BUSINESS'), (2, '2C', 'BUSINESS'), (2, '2D', 'BUSINESS'),
    (2, '10A', 'ECONOMY'), (2, '10B', 'ECONOMY'), (2, '10C', 'ECONOMY'), (2, '10D', 'ECONOMY'),
    (2, '11A', 'ECONOMY'), (2, '11B', 'ECONOMY'), (2, '11C', 'ECONOMY'), (2, '11D', 'ECONOMY'),
    (2, '12A', 'ECONOMY'), (2, '12B', 'ECONOMY'), (2, '12C', 'ECONOMY'), (2, '12D', 'ECONOMY'),

    (3, '1A', 'FIRST'), (3, '1B', 'FIRST'), (3, '1C', 'FIRST'), (3, '1D', 'FIRST'),
    (3, '2A', 'BUSINESS'), (3, '2B', 'BUSINESS'), (3, '2C', 'BUSINESS'), (3, '2D', 'BUSINESS'),
    (3, '10A', 'ECONOMY'), (3, '10B', 'ECONOMY'), (3, '10C', 'ECONOMY'), (3, '10D', 'ECONOMY'),
    (3, '11A', 'ECONOMY'), (3, '11B', 'ECONOMY'), (3, '11C', 'ECONOMY'), (3, '11D', 'ECONOMY'),
    (3, '12A', 'ECONOMY'), (3, '12B', 'ECONOMY'), (3, '12C', 'ECONOMY'), (3, '12D', 'ECONOMY'),

    (4, '1A', 'FIRST'), (4, '1B', 'FIRST'), (4, '1C', 'FIRST'), (4, '1D', 'FIRST'),
    (4, '2A', 'BUSINESS'), (4, '2B', 'BUSINESS'), (4, '2C', 'BUSINESS'), (4, '2D', 'BUSINESS'),
    (4, '10A', 'ECONOMY'), (4, '10B', 'ECONOMY'), (4, '10C', 'ECONOMY'), (4, '10D', 'ECONOMY'),
    (4, '11A', 'ECONOMY'), (4, '11B', 'ECONOMY'), (4, '11C', 'ECONOMY'), (4, '11D', 'ECONOMY'),
    (4, '12A', 'ECONOMY'), (4, '12B', 'ECONOMY'), (4, '12C', 'ECONOMY'), (4, '12D', 'ECONOMY');