CREATE DATABASE bloomon_db_testing;
CREATE USER 'bloomon_db_testing'@'%' IDENTIFIED BY 'bloomon_testing';
GRANT ALL PRIVILEGES ON *.* TO 'bloomon_testing'@'%';
FLUSH PRIVILEGES;