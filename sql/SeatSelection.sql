USE skyline_airlines;

CREATE TABLE IF NOT EXISTS selected_seats (
    selected_seat_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id       INT NOT NULL,
    passenger_id     INT NOT NULL,
    flight_id        INT NOT NULL,
    seat_id          INT NOT NULL,
    selected_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_selected_seat_flight (flight_id, seat_id),
    UNIQUE KEY uq_selected_seat_booking_passenger (booking_id, passenger_id),

    CONSTRAINT fk_selected_seat_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_passenger
        FOREIGN KEY (passenger_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_flight
        FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    CONSTRAINT fk_selected_seat_seat
        FOREIGN KEY (seat_id) REFERENCES seats(seat_id) ON DELETE CASCADE
);
