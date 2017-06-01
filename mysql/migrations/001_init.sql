CREATE DATABASE demo_db_testing;
CREATE USER 'demo_db_testing'@'%' IDENTIFIED BY 'demo_testing';
GRANT ALL PRIVILEGES ON *.* TO 'demo_testing'@'%';
FLUSH PRIVILEGES;
