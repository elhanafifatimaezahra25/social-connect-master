-- Create database
CREATE DATABASE IF NOT EXISTS testdb;

-- Create user (XAMPP usually uses root without password)
-- If root already has password, update this
GRANT ALL PRIVILEGES ON testdb.* TO 'appuser'@'localhost' IDENTIFIED BY 'app123';

-- Or use root user
GRANT ALL PRIVILEGES ON testdb.* TO 'root'@'localhost';

FLUSH PRIVILEGES;

USE testdb;

-- Tables will be created automatically by the application
SELECT 'Database setup complete!' AS status;
