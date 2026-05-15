-- =============================================
-- ADMIN SEED DATA - Custom Emails
-- Run after Airline.sql
-- =============================================
USE skyline_airlines;

DELETE FROM users WHERE role = 'ADMIN';

INSERT INTO users (full_name, email, password, phone, role, status) VALUES
                                                                        ('Kritagya Kumar', 'kritagya95@skyline.admin.com', '$2a$10$IQP96qkGxcLTnEis7rQG8eZAAz.L3O/rzBZaBSEuqZQp2SityKxhm', '9841234561', 'ADMIN', 'APPROVED'),
                                                                        ('Sujal Pariyar', 'sujalP42@skyline.admin.com', '$2a$10$IQP96qkGxcLTnEis7rQG8eZAAz.L3O/rzBZaBSEuqZQp2SityKxhm', '9841234562', 'ADMIN', 'APPROVED'),
                                                                        ('Sujal Tiwari', 'sujalT44@skyline.admin.com', '$2a$10$IQP96qkGxcLTnEis7rQG8eZAAz.L3O/rzBZaBSEuqZQp2SityKxhm', '9841234563', 'ADMIN', 'APPROVED'),
                                                                        ('Binod Tamang', 'binod55@skyline.admin.com', '$2a$10$IQP96qkGxcLTnEis7rQG8eZAAz.L3O/rzBZaBSEuqZQp2SityKxhm', '9841234564', 'ADMIN', 'APPROVED'),
                                                                        ('Prajesh Thapa', 'prajesh20@skyline.admin.com', '$2a$10$IQP96qkGxcLTnEis7rQG8eZAAz.L3O/rzBZaBSEuqZQp2SityKxhm', '9841234565', 'ADMIN', 'APPROVED'),
                                                                        ('Aditya Ale', 'aditya36@skyline.admin.com', '$2a$10$IQP96qkGxcLTnEis7rQG8eZAAz.L3O/rzBZaBSEuqZQp2SityKxhm', '9841234566', 'ADMIN', 'APPROVED');

SELECT '6 Admins seeded successfully' AS Message;