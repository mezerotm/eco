/*
	SQL code for table creation of all database tables for Project ECO
*/

SET time_zone = "+00:00";

/*
	table used to track user information
*/
CREATE TABLE users (
	`session_id` varchar(64) UNIQUE,
	`email_address` varchar(64) NOT NULL,
	`fname` varchar(32) NOT NULL,
	`lname` varchar(32) NOT NULL,
	`created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`last_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	`account_active` BOOLEAN NOT NULL DEFAULT 1,
	PRIMARY KEY (`email_address`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
	table used to track passwords
	-passwords are in a separate table from user information for further security of passwords
*/
CREATE TABLE shadows (
	
	`email_address` varchar(64) NOT NULL,
	`password` varchar(64) NOT NULL,
	`created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`last_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (`email_address`) REFERENCES users(`email_address`),
	PRIMARY KEY (`email_address`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
	table used to track the water usage goals of a user
		- these goals are then used to determine the point value of a data record for the gamification of the system
*/
CREATE TABLE water_goals (
	`goal_id` int(32) NOT NULL AUTO_INCREMENT,
	`start_timestamp` DATETIME NOT NULL,
	`end_timestamp` DATETIME,
	`user_email` varchar(64) NOT NULL,
	PRIMARY KEY (`goal_id`),
	FOREIGN KEY (`user_email`) REFERENCES users(`email_address`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*
	table used to track the friends of a user
	-the table tracks the email address (primary key for users table) of both the user that is the friend, and the user that has the friend
*/
CREATE TABLE friends (
	
	`user1_email` varchar(64) NOT NULL, /* email of the first user in the friendship relationship */
	`user2_email` varchar(64) NOT NULL, /* email of the second user in the friendship relationship */
	`friend_status` tinyint(1) NOT NULL, /* tells if the friend has been approved (1) by user or not (0) */
	PRIMARY KEY (`user1_email`, `user2_email`),
	FOREIGN KEY (`user1_email`) REFERENCES users(`email_address`),
	FOREIGN KEY (`user2_email`) REFERENCES users(`email_address`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*
	table used to track address information
*/
CREATE TABLE addresses (
	
	`address_id` int(32) NOT NULL AUTO_INCREMENT,
	`street_line_1` varchar(32) NOT NULL,
	`street_line_2` varchar(32),
	`city` varchar(32) NOT NULL,
	`state` varchar(32) NOT NULL,
	`country` varchar(32) NOT NULL,
	`zip` int(32) NOT NULL,
	`created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`last_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`address_id`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
	table used to track place information
*/
CREATE TABLE places (
	
	`place_id` int(32) NOT NULL AUTO_INCREMENT,
	`place_name` varchar(32) NOT NULL,
	`place_description` varchar(500),
	`created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`last_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	`user_email` VARCHAR(64) NOT NULL,
	`address_id` int(32),
	PRIMARY KEY (`place_id`),
	FOREIGN KEY (`user_email`) REFERENCES users(`email_address`),
	FOREIGN KEY (`address_id`) REFERENCES addresses(`address_id`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*
	table used to track individual devices
*/
CREATE TABLE devices (
	
	`device_id` int(32) NOT NULL AUTO_INCREMENT,
	`device_sensors_id` int(32) NOT NULL, /*this is the arduino MAC address*/
	`created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`last_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	`place_id` int(32) NOT NULL,
	PRIMARY KEY (`device_id`),
	FOREIGN KEY (`place_id`) REFERENCES places(`place_id`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
	table used to track device groups
*/
CREATE TABLE device_groups (
	
	`group_id` int(32) NOT NULL AUTO_INCREMENT,
	`group_name` varchar(64) NOT NULL,
	`group_description` varchar(500),
	`created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`last_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	`place_id` int(32) NOT NULL,
	PRIMARY KEY (`group_id`),
	FOREIGN KEY (`place_id`) REFERENCES places(`place_id`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
	table used to track devices as they are members of device groups
	-this is used to eliminate the many-to-many relationship between devices and device groups
*/
CREATE TABLE device_group_members (
	
	`device_id` int(32) NOT NULL,
	`group_id` int(32) NOT NULL,
	`created_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`last_modified` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`device_id`, `group_id`),
	FOREIGN KEY (`device_id`) REFERENCES devices(`device_id`),
	FOREIGN KEY (`group_id`) REFERENCES device_groups(`group_id`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
	table used to track device data records
*/
CREATE TABLE data_records (
	
	`record_id` int(32) NOT NULL AUTO_INCREMENT,
	`record_timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`record_liters` int(32) NOT NULL,
	`record_point_value` int(32) NOT NULL,
	`device_id` int(32) NOT NULL,
	PRIMARY KEY (`record_id`),
	FOREIGN KEY (`device_id`) REFERENCES devices(`device_id`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;
