/*
	SQL code for table creation of all database tables for Project ECO
*/

SET time_zone = "+00:00";

/*
	table used to track user information
*/
CREATE TABLE USERS (
  `email_address`    VARCHAR(64) NOT NULL,
  `fname`            VARCHAR(32) NOT NULL,
  `lname`            VARCHAR(32) NOT NULL,
  `created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `last_modified`    DATETIME ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`email_address`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track passwords
	-passwords are in a separate table from user information for further security of passwords
*/
CREATE TABLE SHADOWS (
  `email_address`    VARCHAR(64) NOT NULL,
  `password`         VARCHAR(32) NOT NULL,
  `created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `last_modified`    DATETIME ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`email_address`) REFERENCES USERS (`email_address`),
  PRIMARY KEY (`email_address`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track the friends of a user
	-the table tracks the email address (primary key for USERS table) of both the user that is the friend, and the user that has the friend
*/
CREATE TABLE FRIENDS (
  `friend_email` VARCHAR(64) NOT NULL, /* email of the friend */
  `user_email`   VARCHAR(64) NOT NULL, /* email of the user that "has" this friend */
  PRIMARY KEY (`friend_email`, `user_email`),
  FOREIGN KEY (`friend_email`) REFERENCES USERS (`email_address`),
  FOREIGN KEY (`user_email`) REFERENCES USERS (`email_address`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track address information
*/
CREATE TABLE ADDRESSES (
  `address_id`       INT(32)     NOT NULL AUTO_INCREMENT,
  `street_line_1`    VARCHAR(32) NOT NULL,
  `street_line_2`    VARCHAR(32),
  `city`             VARCHAR(32) NOT NULL,
  `state`            VARCHAR(32) NOT NULL,
  `country`          VARCHAR(32) NOT NULL,
  `zip`              INT(32)     NOT NULL,
  `created_datetime` DATETIME             DEFAULT CURRENT_TIMESTAMP,
  `last_modified`    DATETIME ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track place information
*/
CREATE TABLE PLACES (
  `place_id`          INT(32)     NOT NULL AUTO_INCREMENT,
  `place_name`        VARCHAR(32) NOT NULL,
  `place_description` VARCHAR(500),
  `created_datetime`  DATETIME             DEFAULT CURRENT_TIMESTAMP,
  `last_modified`     DATETIME ON UPDATE CURRENT_TIMESTAMP,
  `address_id`        INT(32),
  PRIMARY KEY (`place_id`),
  # 	FOREIGN KEY (`user_email`) REFERENCES USERS(`email_address`)
  FOREIGN KEY (`address_id`) REFERENCES ADDRESSES (`address_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track individual devices
*/
CREATE TABLE DEVICES (
  `device_id`         INT(32) NOT NULL AUTO_INCREMENT,
  `device_sensors_id` INT(32) NOT NULL, /*this is the devices MAC address*/
  `created_datetime`  DATETIME         DEFAULT CURRENT_TIMESTAMP,
  `last_modified`     DATETIME ON UPDATE CURRENT_TIMESTAMP,
  `place_id`          INT(32) NOT NULL,
  PRIMARY KEY (`device_id`),
  FOREIGN KEY (`place_id`) REFERENCES PLACES (`place_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track device groups
*/
CREATE TABLE DEVICE_GROUPS (
  `group_id`          INT(32)     NOT NULL AUTO_INCREMENT,
  `group_name`        VARCHAR(64) NOT NULL,
  `group_description` VARCHAR(500),
  `created_datetime`  DATETIME             DEFAULT CURRENT_TIMESTAMP,
  `last_modified`     DATETIME ON UPDATE CURRENT_TIMESTAMP,
  `place_id`          INT(32)     NOT NULL,
  PRIMARY KEY (`group_id`),
  FOREIGN KEY (`place_id`) REFERENCES PLACES (`place_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track devices as they are members of device groups
	-this is used to eliminate the many-to-many relationship between devices and device groups
*/
CREATE TABLE DEVICE_GROUP_MEMBERS (
  `device_id`        INT(32) NOT NULL,
  `group_id`         INT(32) NOT NULL,
  `created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `last_modified`    DATETIME ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`, `group_id`),
  FOREIGN KEY (`device_id`) REFERENCES DEVICES (`device_id`),
  FOREIGN KEY (`group_id`) REFERENCES DEVICE_GROUPS (`group_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

/*
	table used to track device data records
*/
CREATE TABLE DATA_RECORDS (
  `record_id`  INT(32) NOT NULL AUTO_INCREMENT,
  `timestamp`  DATETIME         DEFAULT CURRENT_TIMESTAMP,
  `device_id`  INT(32) NOT NULL,
  `data_value` INT(32) NOT NULL,
  PRIMARY KEY (`record_id`),
  FOREIGN KEY (`device_id`) REFERENCES DEVICES (`device_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;
