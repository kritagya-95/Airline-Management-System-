-- Database--
CREATE DATABASE IF NOT EXISTS skyline_airlines
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE skyline_airlines;

-- 1. AIRPORTS
CREATE TABLE airports (
                          airport_id   INT          AUTO_INCREMENT PRIMARY KEY,
                          iata_code    CHAR(3)      NOT NULL UNIQUE,
                          airport_name VARCHAR(150) NOT NULL,
                          city         VARCHAR(100) NOT NULL,
                          country      VARCHAR(100) NOT NULL,
                          timezone     VARCHAR(60)  NOT NULL DEFAULT 'UTC'
);

-- 2. AIRLINES
CREATE TABLE airlines (
                          airline_id   INT          AUTO_INCREMENT PRIMARY KEY,
                          iata_code    CHAR(2)      NOT NULL UNIQUE,
                          airline_name VARCHAR(150) NOT NULL,
                          country      VARCHAR(100),
                          logo_url     VARCHAR(255)
);

-- 3. USERS (must be here before bookings, cancellations, staff, etc.)
CREATE TABLE users (
                       user_id    INT          AUTO_INCREMENT PRIMARY KEY,
                       full_name  VARCHAR(100) NOT NULL,
                       email      VARCHAR(150) NOT NULL UNIQUE,
                       password   VARCHAR(255) NOT NULL,
                       phone      VARCHAR(20),
                       role       ENUM('ADMIN','PASSENGER','STAFF') NOT NULL DEFAULT 'PASSENGER',
                       status     ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
                       created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. AIRCRAFT
CREATE TABLE aircraft (
                          aircraft_id    INT         AUTO_INCREMENT PRIMARY KEY,
                          airline_id     INT         NOT NULL,
                          registration   VARCHAR(20) NOT NULL UNIQUE,
                          model          VARCHAR(80) NOT NULL,
                          total_seats    INT         NOT NULL,
                          economy_seats  INT         NOT NULL DEFAULT 0,
                          business_seats INT         NOT NULL DEFAULT 0,
                          first_seats    INT         NOT NULL DEFAULT 0,
                          CONSTRAINT fk_aircraft_airline FOREIGN KEY (airline_id)
                              REFERENCES airlines(airline_id) ON DELETE CASCADE
);

-- 5. FLIGHTS
CREATE TABLE flights (
                         flight_id          INT           AUTO_INCREMENT PRIMARY KEY,
                         airline_id         INT           NOT NULL,
                         aircraft_id        INT           NOT NULL,
                         flight_number      VARCHAR(10)   NOT NULL,
                         origin_airport_id  INT           NOT NULL,
                         dest_airport_id    INT           NOT NULL,
                         departure_time     DATETIME      NOT NULL,
                         arrival_time       DATETIME      NOT NULL,
                         status             ENUM('SCHEDULED','BOARDING','DEPARTED','ARRIVED','DELAYED','CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
                         base_economy_fare  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                         base_business_fare DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                         base_first_fare    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                         created_at         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         CONSTRAINT fk_flight_airline  FOREIGN KEY (airline_id)        REFERENCES airlines(airline_id),
                         CONSTRAINT fk_flight_aircraft FOREIGN KEY (aircraft_id)       REFERENCES aircraft(aircraft_id),
                         CONSTRAINT fk_flight_origin   FOREIGN KEY (origin_airport_id) REFERENCES airports(airport_id),
                         CONSTRAINT fk_flight_dest     FOREIGN KEY (dest_airport_id)   REFERENCES airports(airport_id)
);

-- 6. SEATS
CREATE TABLE seats (
                       seat_id     INT        AUTO_INCREMENT PRIMARY KEY,
                       aircraft_id INT        NOT NULL,
                       seat_number VARCHAR(5) NOT NULL,
                       class       ENUM('ECONOMY','BUSINESS','FIRST') NOT NULL DEFAULT 'ECONOMY',
                       UNIQUE KEY uq_seat (aircraft_id, seat_number),
                       CONSTRAINT fk_seat_aircraft FOREIGN KEY (aircraft_id)
                           REFERENCES aircraft(aircraft_id) ON DELETE CASCADE
);

-- 7. FLIGHT SEAT AVAILABILITY
CREATE TABLE flight_seat_availability (
                                          availability_id INT        AUTO_INCREMENT PRIMARY KEY,
                                          flight_id       INT        NOT NULL,
                                          seat_id         INT        NOT NULL,
                                          is_available    TINYINT(1) NOT NULL DEFAULT 1,
                                          UNIQUE KEY uq_flight_seat (flight_id, seat_id),
                                          CONSTRAINT fk_fsa_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
                                          CONSTRAINT fk_fsa_seat   FOREIGN KEY (seat_id)   REFERENCES seats(seat_id)     ON DELETE CASCADE
);

-- 8. BOOKINGS
CREATE TABLE bookings (
                          booking_id     INT           AUTO_INCREMENT PRIMARY KEY,
                          user_id        INT           NOT NULL,
                          flight_id      INT           NOT NULL,
                          booking_ref    VARCHAR(10)   NOT NULL UNIQUE,
                          class          ENUM('ECONOMY','BUSINESS','FIRST') NOT NULL DEFAULT 'ECONOMY',
                          num_passengers INT           NOT NULL DEFAULT 1,
                          total_fare     DECIMAL(10,2) NOT NULL,
                          booking_status ENUM('CONFIRMED','PENDING','CANCELLED') NOT NULL DEFAULT 'PENDING',
                          created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          CONSTRAINT fk_booking_user   FOREIGN KEY (user_id)   REFERENCES users(user_id),
                          CONSTRAINT fk_booking_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- 9. BOOKING PASSENGERS
CREATE TABLE booking_passengers (
                                    passenger_id INT          AUTO_INCREMENT PRIMARY KEY,
                                    booking_id   INT          NOT NULL,
                                    seat_id      INT,
                                    full_name    VARCHAR(100) NOT NULL,
                                    passport_no  VARCHAR(30),
                                    dob          DATE,
                                    nationality  VARCHAR(60),
                                    CONSTRAINT fk_bp_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
                                    CONSTRAINT fk_bp_seat    FOREIGN KEY (seat_id)    REFERENCES seats(seat_id)
);

-- 10. PAYMENTS
CREATE TABLE payments (
                          payment_id     INT           AUTO_INCREMENT PRIMARY KEY,
                          booking_id     INT           NOT NULL UNIQUE,
                          amount         DECIMAL(10,2) NOT NULL,
                          currency       CHAR(3)       NOT NULL DEFAULT 'NPR',
                          method         ENUM('CREDIT_CARD','DEBIT_CARD','NET_BANKING','ESEWA','KHALTI','CASH') NOT NULL DEFAULT 'CREDIT_CARD',
                          status         ENUM('PENDING','COMPLETED','FAILED','REFUNDED') NOT NULL DEFAULT 'PENDING',
                          transaction_id VARCHAR(100),
                          paid_at        TIMESTAMP,
                          CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id)
                              REFERENCES bookings(booking_id) ON DELETE CASCADE
);

-- 11. TICKETS
CREATE TABLE tickets (
                         ticket_id     INT         AUTO_INCREMENT PRIMARY KEY,
                         booking_id    INT         NOT NULL,
                         passenger_id  INT         NOT NULL,
                         ticket_number VARCHAR(15) NOT NULL UNIQUE,
                         issued_at     TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         qr_data       TEXT,
                         CONSTRAINT fk_ticket_booking   FOREIGN KEY (booking_id)   REFERENCES bookings(booking_id),
                         CONSTRAINT fk_ticket_passenger FOREIGN KEY (passenger_id) REFERENCES booking_passengers(passenger_id)
);

-- 12. CANCELLATIONS
CREATE TABLE cancellations (
                               cancellation_id     INT       AUTO_INCREMENT PRIMARY KEY,
                               booking_id          INT       NOT NULL UNIQUE,
                               cancelled_by        INT       NOT NULL,
                               reason              TEXT,
                               cancellation_status ENUM('REQUESTED','APPROVED','REJECTED') NOT NULL DEFAULT 'REQUESTED',
                               requested_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               processed_at        TIMESTAMP,
                               CONSTRAINT fk_cancel_booking FOREIGN KEY (booking_id)   REFERENCES bookings(booking_id),
                               CONSTRAINT fk_cancel_user    FOREIGN KEY (cancelled_by) REFERENCES users(user_id)
);

-- 13. REFUNDS
CREATE TABLE refunds (
                         refund_id       INT           AUTO_INCREMENT PRIMARY KEY,
                         cancellation_id INT           NOT NULL UNIQUE,
                         payment_id      INT           NOT NULL,
                         refund_amount   DECIMAL(10,2) NOT NULL,
                         refund_status   ENUM('PENDING','PROCESSED','REJECTED') NOT NULL DEFAULT 'PENDING',
                         refund_method   VARCHAR(50),
                         processed_at    TIMESTAMP,
                         CONSTRAINT fk_refund_cancel  FOREIGN KEY (cancellation_id) REFERENCES cancellations(cancellation_id),
                         CONSTRAINT fk_refund_payment FOREIGN KEY (payment_id)      REFERENCES payments(payment_id)
);

-- 14. STAFF
CREATE TABLE staff (
                       staff_id      INT         AUTO_INCREMENT PRIMARY KEY,
                       user_id       INT         NOT NULL UNIQUE,
                       employee_code VARCHAR(20) NOT NULL UNIQUE,
                       designation   VARCHAR(80) NOT NULL,
                       department    VARCHAR(80),
                       hire_date     DATE,
                       CONSTRAINT fk_staff_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 15. FLIGHT STATUS LOG
CREATE TABLE flight_status_log (
                                   log_id     INT          AUTO_INCREMENT PRIMARY KEY,
                                   flight_id  INT          NOT NULL,
                                   old_status VARCHAR(20),
                                   new_status VARCHAR(20)  NOT NULL,
                                   changed_by INT,
                                   reason     VARCHAR(255),
                                   changed_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   CONSTRAINT fk_fsl_flight FOREIGN KEY (flight_id)  REFERENCES flights(flight_id),
                                   CONSTRAINT fk_fsl_user   FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

-- 16. NOTIFICATIONS
CREATE TABLE notifications (
                               notification_id INT          AUTO_INCREMENT PRIMARY KEY,
                               user_id         INT          NOT NULL,
                               title           VARCHAR(150) NOT NULL,
                               message         TEXT         NOT NULL,
                               is_read         TINYINT(1)   NOT NULL DEFAULT 0,
                               created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 17. AUDIT LOGS
CREATE TABLE audit_logs (
                            audit_id    INT          AUTO_INCREMENT PRIMARY KEY,
                            user_id     INT,
                            action      VARCHAR(100) NOT NULL,
                            entity_type VARCHAR(50),
                            entity_id   INT,
                            description TEXT,
                            ip_address  VARCHAR(45),
                            created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 18. REPORTS
CREATE TABLE reports (
                         report_id    INT          AUTO_INCREMENT PRIMARY KEY,
                         report_name  VARCHAR(150) NOT NULL,
                         report_type  ENUM('REVENUE','BOOKING','PASSENGER','FLIGHT','CANCELLATION') NOT NULL,
                         generated_by INT          NOT NULL,
                         parameters   TEXT,
                         file_path    VARCHAR(255),
                         generated_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         CONSTRAINT fk_report_user FOREIGN KEY (generated_by) REFERENCES users(user_id)
);


-- SAMPLE DATA--


INSERT INTO airports (iata_code, airport_name, city, country, timezone) VALUES
                                                                            ('KTM', 'Tribhuvan International Airport',     'Kathmandu', 'Nepal',    'Asia/Kathmandu'),
                                                                            ('DEL', 'Indira Gandhi International Airport', 'New Delhi',  'India',   'Asia/Kolkata'),
                                                                            ('DXB', 'Dubai International Airport',         'Dubai',      'UAE',     'Asia/Dubai'),
                                                                            ('DOH', 'Hamad International Airport',         'Doha',       'Qatar',   'Asia/Qatar'),
                                                                            ('BKK', 'Suvarnabhumi Airport',                'Bangkok',    'Thailand','Asia/Bangkok');

INSERT INTO airlines (iata_code, airline_name, country) VALUES
                                                            ('RA', 'Nepal Airlines', 'Nepal'),
                                                            ('9N', 'Tropic Air',     'Nepal'),
                                                            ('EK', 'Emirates',       'UAE');

INSERT INTO aircraft (airline_id, registration, model, total_seats, economy_seats, business_seats, first_seats) VALUES
                                                                                                                    (1, '9N-AKW', 'Boeing 757-200', 167, 137, 30,  0),
                                                                                                                    (1, '9N-ABB', 'Airbus A320',    162, 132, 30,  0),
                                                                                                                    (3, 'A6-EEW', 'Boeing 777-300', 360, 304, 42, 14);

INSERT INTO seats (aircraft_id, seat_number, class) VALUES
                                                        (1,'1A','BUSINESS'),(1,'1B','BUSINESS'),(1,'1C','BUSINESS'),
                                                        (1,'2A','BUSINESS'),(1,'2B','BUSINESS'),(1,'2C','BUSINESS'),
                                                        (1,'10A','ECONOMY'),(1,'10B','ECONOMY'),(1,'10C','ECONOMY'),
                                                        (1,'11A','ECONOMY'),(1,'11B','ECONOMY'),(1,'11C','ECONOMY');

INSERT INTO flights (airline_id, aircraft_id, flight_number, origin_airport_id, dest_airport_id,
                     departure_time, arrival_time, status, base_economy_fare, base_business_fare) VALUES
                                                                                                      (1, 1, 'RA201', 1, 2, '2025-06-01 08:00:00', '2025-06-01 09:30:00', 'SCHEDULED',  8500.00,  25000.00),
                                                                                                      (1, 2, 'RA202', 2, 1, '2025-06-01 12:00:00', '2025-06-01 13:30:00', 'SCHEDULED',  8500.00,  25000.00),
                                                                                                      (3, 3, 'EK612', 1, 3, '2025-06-02 22:30:00', '2025-06-03 01:30:00', 'SCHEDULED', 45000.00, 120000.00);


-- VIEWS--


CREATE OR REPLACE VIEW v_flight_search AS
SELECT
    f.flight_id,
    f.flight_number,
    al.airline_name,
    oa.iata_code        AS origin_code,
    oa.city             AS origin_city,
    da.iata_code        AS dest_code,
    da.city             AS dest_city,
    f.departure_time,
    f.arrival_time,
    TIMEDIFF(f.arrival_time, f.departure_time) AS duration,
    f.status,
    f.base_economy_fare,
    f.base_business_fare,
    f.base_first_fare,
    ac.total_seats,
    (SELECT COUNT(*) FROM flight_seat_availability fsa
     WHERE fsa.flight_id = f.flight_id AND fsa.is_available = 0) AS booked_seats
FROM flights f
         JOIN airlines al ON al.airline_id       = f.airline_id
         JOIN airports oa ON oa.airport_id       = f.origin_airport_id
         JOIN airports da ON da.airport_id       = f.dest_airport_id
         JOIN aircraft ac ON ac.aircraft_id      = f.aircraft_id;

CREATE OR REPLACE VIEW v_booking_summary AS
SELECT
    b.booking_id,
    b.booking_ref,
    u.full_name         AS passenger_name,
    u.email,
    f.flight_number,
    oa.iata_code        AS from_airport,
    da.iata_code        AS to_airport,
    f.departure_time,
    b.class,
    b.num_passengers,
    b.total_fare,
    b.booking_status,
    p.status            AS payment_status,
    b.created_at
FROM bookings b
         JOIN users    u  ON u.user_id        = b.user_id
         JOIN flights  f  ON f.flight_id      = b.flight_id
         JOIN airports oa ON oa.airport_id    = f.origin_airport_id
         JOIN airports da ON da.airport_id    = f.dest_airport_id
         LEFT JOIN payments p ON p.booking_id = b.booking_id;