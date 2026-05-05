

USE skyline_airlines;

-- password = "Admin@123" BCrypt hashed
INSERT INTO users (full_name, email, password, phone, role, status) VALUES
                                                                        ('Sky Admin',    'admin@skyline.com',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9800000001', 'ADMIN',     'APPROVED'),
                                                                        ('Ram Thapa',    'ram@example.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9811111111', 'PASSENGER', 'APPROVED'),
                                                                        ('Sita Sharma',  'sita@example.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9822222222', 'PASSENGER', 'PENDING'),
                                                                        ('Gate Agent 1', 'staff1@skyline.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVdxx8.oG2', '9833333333', 'STAFF',     'APPROVED');

-- Staff entry for Gate Agent 1 (user_id = 4)
INSERT INTO staff (user_id, employee_code, designation, department, hire_date) VALUES
    (4, 'EMP-001', 'Gate Agent', 'Ground Operations', '2023-01-15');