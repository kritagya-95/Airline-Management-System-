USE skyline_airlines;

-- Safely clear out old admin attempts to avoid duplicate entry errors
DELETE FROM users WHERE role = 'ADMIN';

-- Insert the admin rows with a fresh, verified standard BCrypt hash for 'Admin@95'
INSERT INTO users (full_name, email, password, phone, role, status) VALUES
                                                                        ('Kritagya Kumar', 'kritagya95@skyline.admin.com', '$2a$12$Z0m08e0K9v81Dbebe3X3bOfA7E7U27RkR6jG8O/z7l0g3H6dWeK2G', '9841234561', 'ADMIN', 'APPROVED'),
                                                                        ('Sujal Pariyar', 'sujalP42@skyline.admin.com', '$2a$12$Z0m08e0K9v81Dbebe3X3bOfA7E7U27RkR6jG8O/z7l0g3H6dWeK2G', '9841234562', 'ADMIN', 'APPROVED'),
                                                                        ('Sujal Tiwari', 'sujalT44@skyline.admin.com', '$2a$12$Z0m08e0K9v81Dbebe3X3bOfA7E7U27RkR6jG8O/z7l0g3H6dWeK2G', '9841234563', 'ADMIN', 'APPROVED'),
                                                                        ('Binod Tamang', 'binod55@skyline.admin.com', '$2a$12$Z0m08e0K9v81Dbebe3X3bOfA7E7U27RkR6jG8O/z7l0g3H6dWeK2G', '9841234564', 'ADMIN', 'APPROVED'),
                                                                        ('Prajesh Thapa', 'prajesh20@skyline.admin.com', '$2a$12$Z0m08e0K9v81Dbebe3X3bOfA7E7U27RkR6jG8O/z7l0g3H6dWeK2G', '9841234565', 'ADMIN', 'APPROVED'),
                                                                        ('Aditya Ale', 'aditya36@skyline.admin.com', '$2a$12$Z0m08e0K9v81Dbebe3X3bOfA7E7U27RkR6jG8O/z7l0g3H6dWeK2G', '9841234566', 'ADMIN', 'APPROVED');

SELECT '6 Admins refreshed inside skyline_airlines' AS Message;