-- 1. Disable checks to allow cleanup
SET FOREIGN_KEY_CHECKS = 0;

USE skyline_airlines;


CREATE TABLE IF NOT EXISTS users (
                                     user_id INT AUTO_INCREMENT PRIMARY KEY,
                                     full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('ADMIN', 'STAFF', 'PASSENGER') NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING'
    );

-- 3. Clear data (Order matters for Foreign Keys)
DELETE FROM audit_logs;
DELETE FROM staff;
DELETE FROM users;

-- 4. Reset counters
ALTER TABLE users AUTO_INCREMENT = 1;
ALTER TABLE staff AUTO_INCREMENT = 1;


INSERT INTO users (full_name, email, password, phone, role, status)
VALUES (
           'System Administrator',
           'admin@skyline.com',
           '$2a$10$8.V9TrkeS9.79Lp9P.S9Pe9P7p9P7p9P7p9P7p9P7p9P7p9P7p9P7',
           '1234567890',
           'ADMIN',
           'APPROVED'
       );


INSERT INTO users (full_name, email, password, phone, role, status)
VALUES (
           'Operations Manager',
           'staff@skyline.com',
           '$2a$10$8.V9TrkeS9.79Lp9P.S9Pe9P7p9P7p9P7p9P7p9P7p9P7p9P7p9P7',
           '0987654321',
           'STAFF',
           'APPROVED'
       );

-- 7. Link Staff Details
INSERT INTO staff (user_id, employee_code, designation, department, hire_date)
VALUES (2, 'SK-1001', 'Chief Flight Controller', 'Operations', CURDATE());

-- 8. Re-enable checks
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Database Refined and Seeded' AS Status;
