/*
	stored procedures for the places table
*/

DELIMITER //

/*
	creates a new place for the given user
	@param email the email address of the user who is adding this place
*/
CREATE PROCEDURE create_place(IN `email` VARCHAR(64), IN `place_name` VARCHAR(32))
	BEGIN
	IF EXISTS (SELECT *
			FROM `users` as u
			WHERE u.`email_address` = `email`) THEN
		INSERT INTO `places` (`place_name`, `user_email`)
		VALUES (`email`, `place_name`);
	END IF;
	END //

/*
	get a place given the place id
	@param id
*/
CREATE PROCEDURE get_place(IN `id` int(32))
	BEGIN
	IF EXISTS (SELECT * FROM `places` where `place_id` = `id`) THEN
		SELECT *
		FROM `places`
		WHERE `place_id` = `id`;
	END IF;
	END //


/*
	get all place id's given a user's email
	@param email the email of the user getting the places
*/
CREATE PROCEDURE get_places_from_user(IN `email` VARCHAR(64))
	BEGIN
	IF EXISTS (SELECT *
		FROM `users` as u
		WHERE u.`email_address` = `email`) THEN
		SELECT `place_id`
		FROM `places` as p
		WHERE p.`user_email` = `email`;
	END IF;
	END //

/*
	get the address of a place
	@param place_id the id of the place whose address is being looked up
*/
CREATE PROCEDURE get_address_of_place(IN `place_id` int(32))
	BEGIN
	SELECT *
	FROM `addresses` as a
	WHERE a.`place_id` = `place_id`;
	END //


DELIMITER ;