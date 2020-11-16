CREATE DATABASE company;

USE company;

CREATE TABLE jobs
(
ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
RecordNumber VARCHAR(64), -- This is the UUID
CustomerName VARCHAR(64),
Email VARCHAR(64),
Phone VARCHAR(64),
Stat INT(1) DEFAULT 0, -- Job status, not done is 0, done is 1
S3URL VARCHAR(200) -- set the returned S3URL here
);