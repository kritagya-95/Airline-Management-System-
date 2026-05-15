-- =============================================
-- STAFF SEED DATA - Custom Emails
-- =============================================
USE skyline_airlines;

DELETE FROM users WHERE role = 'STAFF';

INSERT INTO users (full_name, email, password, phone, role, status) VALUES
                                                                        ('Kritagya Kumar', 'kritagya95@skyline.staff.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9841000001', 'STAFF', 'APPROVED'),
                                                                        ('Sujal Pariyar', 'sujalP42@skyline.staff.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9841000002', 'STAFF', 'APPROVED'),
                                                                        ('Sujal Tiwari', 'sujalT44@skyline.staff.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9841000003', 'STAFF', 'APPROVED'),
                                                                        ('Binod Tamang', 'binod55@skyline.staff.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9841000004', 'STAFF', 'APPROVED'),
                                                                        ('Prajesh Thapa', 'prajesh20@skyline.staff.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9841000005', 'STAFF', 'APPROVED'),
                                                                        ('Aditya Ale', 'aditya36@skyline.staff.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9841000006', 'STAFF', 'APPROVED');

-- Create staff records
INSERT INTO staff (user_id, employee_code, designation, department, hire_date)
SELECT user_id, CONCAT('EMP', LPAD(user_id, 3, '0')), 'Staff Member', 'Operations', CURDATE()
FROM users WHERE role = 'STAFF';

SELECT ' 6 Staff members seeded successfully' AS Message;