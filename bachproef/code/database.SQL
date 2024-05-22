/* Create Database */

CREATE DATABASE IF NOT EXISTS `bap_telephony`;

/* Use Database */

USE `bap_telephony`;

/* Create Tables */

CREATE TABLE IF NOT EXISTS `User` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `username` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS `Telephone_Number` (
    `id` int NOT NULL AUTO_INCREMENT,
    `number` varchar(255) NOT NULL,
    `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `User`(`id`));


CREATE TABLE IF NOT EXISTS `Call_Log` (
    `id` int NOT NULL AUTO_INCREMENT,
    `telephone_number_id` int NOT NULL,
    `from_number` varchar(255) NOT NULL,
    `to_number` varchar(255) NOT NULL,
    `duration` int NOT NULL,
    `call_date` datetime NOT NULL,
    `call_type` varchar(10) NOT NULL,
    `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`telephone_number_id`) REFERENCES `Telephone_Number`(`id`));

insert into `User` (`name`, `username`, `password`) values ('John Doe', 'user1', 'password');
insert into `User` (`name`, `username`, `password`) values ('Jane Doe', 'user2', 'password');
insert into `User` (`name`, `username`, `password`) values ('Alice Doe', 'user3', 'password');

insert into `Telephone_Number` (`number`, `user_id`) values ('1234567890', 1);
insert into `Telephone_Number` (`number`, `user_id`) values ('0987654321', 2);
insert into `Telephone_Number` (`number`, `user_id`) values ('1231231234', 3);
insert into `Telephone_Number` (`number`, `user_id`) values ('4564564567', 3);

-- create 10000 call log entries
DELIMITER $$

CREATE PROCEDURE `create_call_logs`()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE from_number VARCHAR(255);
    DECLARE to_number VARCHAR(255);
    DECLARE duration INT;
    DECLARE call_date DATETIME;
    DECLARE call_type VARCHAR(10);
    DECLARE price DECIMAL(10,2);
    DECLARE telephone_number_id INT;

    WHILE i < 10000 DO
        -- Select a random from_number that exists in the Telephone_Number table
        REPEAT
            SET from_number = (SELECT number FROM Telephone_Number ORDER BY RAND() LIMIT 1);
        UNTIL EXISTS (SELECT id FROM Telephone_Number WHERE number = from_number) END REPEAT;

        -- Determine the to_number and call_type
        SET to_number = CASE 
                            WHEN RAND() < 0.75 THEN (SELECT number FROM Telephone_Number ORDER BY RAND() LIMIT 1)
                            WHEN RAND() < 0.75 THEN 'SMS'
                            ELSE 'DATA'
                       END;

        SET call_type = CASE 
                            WHEN to_number = 'SMS' THEN 'sms'
                            WHEN to_number = 'DATA' THEN 'data'
                            ELSE 'call'
                       END;

        SET duration = CASE
							WHEN to_number = 'SMS' THEN 1
                            ELSE FLOOR(RAND() * 100)
						END;
        SET call_date = NOW() - INTERVAL FLOOR(RAND() * 35) DAY;
        SET price = FLOOR(RAND() * 100) / 100;
        SET telephone_number_id = (SELECT id FROM Telephone_Number WHERE number = from_number);

        INSERT INTO Call_Log (telephone_number_id, from_number, to_number, duration, call_date, call_type, price) VALUES (telephone_number_id, from_number, to_number, duration, call_date, call_type, price);

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL create_call_logs();