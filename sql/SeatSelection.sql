USE skyline_airlines;

CREATE TABLE IF NOT EXISTS selected_seats (
    selected_seat_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id       INT NOT NULL,
    passenger_id     INT NOT NULL,
    flight_id        INT NOT NULL,
    seat_id          INT NOT NULL,
    selected_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_selected_seat_flight (flight_id, seat_id),
    KEY idx_selected_seat_booking (booking_id),

    CONSTRAINT fk_selected_seat_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_passenger
        FOREIGN KEY (passenger_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_flight
        FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_seat
        FOREIGN KEY (seat_id) REFERENCES seats(seat_id) ON DELETE CASCADE
);

-- Ensure every seeded aircraft has selectable seats for the booking flow.
-- Existing aircraft 1 seats are preserved; these rows only fill missing aircraft.
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
