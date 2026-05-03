-- =============================================================
--  SKYLINE AIRLINES — Users Table
-- =============================================================

USE skyline_airlines;

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

-- Sample Users (password = "Admin@123" BCrypt hashed)
INSERT INTO users (full_name, email, password, phone, role, status) VALUES
('Sky Admin',    'admin@skyline.com',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9800000001', 'ADMIN',     'APPROVED'),
('Ram Thapa',    'ram@example.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9811111111', 'PASSENGER', 'APPROVED'),
('Sita Sharma',  'sita@example.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9822222222', 'PASSENGER', 'PENDING'),
('Gate Agent 1', 'staff1@skyline.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9833333333', 'STAFF',     'APPROVED');