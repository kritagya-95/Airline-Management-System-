USE skyline_airlines;

-- =============================================
-- CLEAR ALL EXISTING USERS (Fresh Start)
-- =============================================

DELETE FROM staff;
DELETE FROM users;

-- Optional: Reset AUTO_INCREMENT
ALTER TABLE users AUTO_INCREMENT = 1;
ALTER TABLE staff AUTO_INCREMENT = 1;

-- =============================================
-- Message
-- =============================================
SELECT 'All users have been cleared. You can now register new accounts.' AS Message;