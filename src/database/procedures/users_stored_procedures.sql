/*
	stored procedures for users table and other user-related operations
*/


DELIMITER //


/*
	a simple date-time format function
*/
CREATE PROCEDURE format_datetime_full(IN `value` DATETIME)
	BEGIN
	SELECT DATE_FORMAT(`value`, '%Y-%m-%d %T.%f');
	END //

/*
	get the email of a user based on their session id
	@param sess_id the session id of the user
*/
CREATE PROCEDURE get_email_from_session_id(IN `sess_id` VARCHAR(64))
	BEGIN
	SELECT `email_address`
	FROM `users` as u
	WHERE u.`session_id` = `sess_id`;
	END //


/*
	a retrieval query for a single user
	@param user_email the email address of the user whose data is being retrieved
	@return a sql query holding a single user if a match is found, null if not found
*/
CREATE PROCEDURE get_user(IN `user_email` VARCHAR(64))
	BEGIN
	SELECT *
	FROM `users` as u
	WHERE u.`email_address` = `user_email` AND u.`account_active` = 1; /*make sure the account is not deleted */
	END //

/*
	a query that gets the first name of the user with the specified email
	@param email the email address of the user
	@return the first name of the user
*/
CREATE PROCEDURE get_user_fname(IN `email` VARCHAR(64))
	BEGIN
	SELECT `fname`
	FROM `users` as u
	WHERE u.`email_address` = `email`;
	END //

/*
	a query that gets the last name of the user with the specified email
	@param email the email address of the user
	@return the last name of the user
*/
CREATE PROCEDURE get_user_lname(IN `email` VARCHAR(64))
	BEGIN
	SELECT `lname`
	FROM `users` as u
	WHERE u.`email_address` = `email`;
	END //

/*
	a query that gets the date and time that the user was created
	@param email the email address of the user
	@return a formatted string of the date and time the user was created
*/
CREATE PROCEDURE get_user_created_timestamp(IN `email` VARCHAR(64))
	BEGIN
	DECLARE datetime_value DATETIME;
	SET datetime_value = (SELECT `created_datetime`
		FROM `users` as u
		WHERE u.`email_address` = `email`);
	CALL format_datetime_full(datetime_value);
	END //

/*
	a query that gets the date and time that the use was last modified
	@param email the email address of the user
	@return a formatted string of the date and time the user was last modified
*/
CREATE PROCEDURE get_user_last_modified_timestamp(IN `email` VARCHAR(64))
	BEGIN
	DECLARE datetime_value DATETIME;
	SET datetime_value = (SELECT `last_modified`
		FROM `users` as u
		WHERE u.`email_address` = `email`);
	IF datetime_value IS NULL THEN
		CALL get_user_created_timestamp(`email`);
	ELSE
		CALL format_datetime_full(datetime_value);
	END IF;
	END //

/*
	a query that returns the account status of this user
	@param email the email address of the user
	@return 'active' if the account is active, 'deleted' if account is inactive
*/
CREATE PROCEDURE get_user_status(IN `email` VARCHAR(64))
	BEGIN
	DECLARE status_value TINYINT(1);
	SET status_value = (SELECT `account_active`
		FROM `users` as u
		WHERE u.`email_address` = `email`);
	IF status_value = 0 THEN
		SELECT 'Account Deleted' as 'account_active';
	ELSE
		SELECT 'Account Active' as 'account_active';
	END IF;
	END //

/*
	a create procedure for users
	@param email the email address of the new user
	@param fname the first name of the new user
	@param lname the last name of the new user
*/
CREATE PROCEDURE create_user(IN `user_email` VARCHAR(64), IN `user_fname` VARCHAR(32), IN `user_lname` VARCHAR(32))
	BEGIN
	INSERT INTO `users` (`email_address`, `fname`, `lname`, `account_active`)
	VALUES (`user_email`, `user_fname`, `user_lname`, 1);
	END //

/*
	'removes' a user account by setting the account status to inactive
	@param user_email the email address of the user being removed
*/
CREATE PROCEDURE remove_user(IN `user_email` VARCHAR(64))
	BEGIN
	UPDATE `users`
	SET `account_active` = 0
	WHERE `email_address` = `user_email`;
	END //

/*
	updates the user's email address if possible
	@param user_email the current email address of the user being updated
	@param new_email the new email address of the user
*/
CREATE PROCEDURE update_user_email(IN `user_email` VARCHAR(64), IN `new_email` VARCHAR(64))
	BEGIN
	IF NOT EXISTS (SELECT * 
			FROM `users` as u
			WHERE u.`email_address` = `new_email`) THEN
		UPDATE `users`
		SET `email_address` = `new_email`
		WHERE `email_address` = `user_email`;
	END IF;
	END //

/*
	updates the user's first name
	@param new_fname the new first name
	@param email the email address of the user whose name is being updated
*/
CREATE PROCEDURE update_user_fname(IN `email` VARCHAR(64), IN `new_fname` VARCHAR(32))
	BEGIN
	UPDATE `users`
	SET `fname` = `new_fname`
	WHERE `email_address` = `email`;
	END //

/*
	updates the user's last name
	@param new_lname the new last name
	@param email the email address of the user whose name is being updated
*/
CREATE PROCEDURE update_user_lname(IN `email` VARCHAR(64), IN `new_lname` VARCHAR(32))
	BEGIN
	UPDATE `users`
	SET `lname` = `new_lname`
	WHERE `email_address` = `email`;
	END //

/*
	adds a user as a friend
	@param user_email the email address of the user adding the friend
	@param add_friend_email the email address of the user being added as a friend
*/
CREATE PROCEDURE add_friend(IN `user_email` VARCHAR(64), IN `add_friend_email` VARCHAR(64))
	BEGIN
	/* make sure this specific friend is not already added by this user */
	IF NOT (`user_email` = `add_friend_email`) 
		AND NOT EXISTS (SELECT *
			FROM `friends` as f
			WHERE f.`user2_email` = `user_email` AND f.`user1_email` = `add_friend_email`)
		AND EXISTS (SELECT * 
			FROM `users` as u
			WHERE u.`email_address` = `user_email` OR u.`email_address` = `add_friend_email`) THEN
		/* add the friend */
		INSERT INTO `friends` (`user1_email`, `user2_email`, `friend_status`)
		VALUES (`add_friend_email`, `user_email`, 1); /* add friend as a pending friend (friend_status = 0) */
	END IF;
	END //

/*
	confirms a user as a friend (adds the user who sent the friend request to this user's friend list and sets friend status to 1 (friend request confirmed))
	@param receiver_email the email address of the friend who received the friend request
	@param sender_email the email address of the friend who sent the friend request
*/
CREATE PROCEDURE confirm_friend(IN `receiver_email` VARCHAR(64), IN `sender_email` VARCHAR(64))
	BEGIN
	IF NOT `receiver_email` = `sender_email`
		AND EXISTS (SELECT *
			FROM `friends` as f
			WHERE f.`user1_email` = `sender_email` AND f.`user2_email` = `receiver_email` OR f.`user1_email` = `receiver_email` AND f.`user2_email` = `sender_email`) THEN
		/* confirm the friend request on the sender's side */
		UPDATE `friends`
		SET `friend_status` = 1
		WHERE (`user2_email` = `receiver_email` AND `user1_email` = `sender_email`) OR (`user1_email` = `receiver_email` AND `user2_email` = `sender_email`);
	END IF;
	END //

/*
	gets all users in the given user's friends list and returns their email address, first name, and last name
	@param user_email the email address of the user whose friends list is being queried
*/
CREATE PROCEDURE get_friends_list(IN `user_email` VARCHAR(64))
	BEGIN
	SELECT u.`email_address`, u.`fname`, u.`lname`
	FROM `friends` as f
	INNER JOIN `users` as u ON f.`user1_email` = u.`email_address`
	WHERE f.`friend_status` = 1 AND f.`user2_email` = `user_email` AND u.`account_active` = 1
	UNION ALL
	SELECT u.`email_address`, u.`fname`, u.`lname`
	FROM `friends` as f
	INNER JOIN `users` as u ON f.`user2_email` = u.`email_address`
	WHERE f.`friend_status` = 1 AND f.`user1_email` = `user_email` AND u.`account_active` = 1;
	END //

/*
	get the friendship relationship instance between the 2 specified users
	@param user1 the first user in the friend relationship
	@param user2 the second user in the friend relationship
*/
CREATE PROCEDURE get_friend_instance(IN `user1` VARCHAR(64), IN `user2` VARCHAR(64))
	BEGIN
	SELECT *
	FROM `friends` as f
	WHERE (f.`user1_email` = `user1` AND f.`user2_email` = `user2`) OR (f.`user2_email` = `user1` AND f.`user1_email` = `user2`);
	END //

/*
	given a user email, return the password (encrypted)
	@param email the email of the user being validated
*/
CREATE PROCEDURE verify_password(IN `email` VARCHAR(64))
	BEGIN
	SELECT s.`password`
	FROM `users` as u
	INNER JOIN `shadows` as s ON u.`email_address` = s.`email_address`
	WHERE u.`email_address` = `email`;
	END //

/*
	set the password of a user given their email
	@param email the email of the user whose password is being set
	@param password_in the password that is being set
*/
CREATE PROCEDURE set_password(IN `email` VARCHAR(64), IN `password_in` VARCHAR(64))
	BEGIN
	IF EXISTS (SELECT *
			FROM `shadows` as s
			WHERE s.`email_address` = `email`) THEN
		UPDATE `shadows`
		SET `password` = `password_in`
		WHERE `email_address` = `email`;
	ELSEIF EXISTS (SELECT *
			FROM `users` as u
			WHERE u.`email_address` = `email`) THEN
		INSERT INTO `shadows` (`email_address`, `password`)
		VALUES(`email`, `password_in`);
	END IF;
	END //

/*
	sets the session id of the user
	@param email the email address of the user whose session id is being set
	@param session_id_in the session id that is being set to
*/
CREATE PROCEDURE set_session_id(IN `email` VARCHAR(64), IN `session_id_in` VARCHAR(64))
	BEGIN
	IF EXISTS (SELECT *
		FROM `users` as u
		WHERE u.`email_address` = `email`) THEN
		UPDATE `users`
		SET `session_id` = `session_id_in`
		WHERE `email_address` = `email`;
	END IF;
	END //

DELIMITER ;