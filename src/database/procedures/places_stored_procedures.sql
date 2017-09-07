/*
	stored procedures for the places table
*/

DELIMITER //

/*
	creates a new place for the given user
	@param email the email address of the user who is adding this place
*/
CREATE PROCEDURE create_place(IN `email` VARCHAR(64), IN `name` VARCHAR(32))
	BEGIN
	IF EXISTS (SELECT *
			FROM `users` as u
			WHERE u.`email_address` = `email`) THEN
		INSERT INTO `places` (`place_name`, `user_email`)
		VALUES (`name`, `email`);
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
	IF EXISTS (SELECT * FROM `users` as u WHERE u.`email_address` = `email` AND u.`account_active` = 1) THEN
		SELECT `place_id`
		FROM `places` as p
		WHERE p.`user_email` = `email`;
	END IF;
	END //

/*
	get the address of a place
	@param place_id the id of the place whose address is being looked up
*/
CREATE PROCEDURE get_address_of_place(IN `place_id_in` int(32))
	BEGIN
	SELECT a.`address_id`
	FROM `addresses` as a
	INNER JOIN `places` as p
	ON a.`address_id` = p.`address_id`
	WHERE p.`place_id` = `place_id_in`;
	END //

/*
	create a new place
	@param name_in the name of the place
	@param email the id of the user that is creating this place
*/
CREATE PROCEDURE create_place(IN `name_in` varchar(32), IN `email` int(32))
	BEGIN
	IF EXISTS(SELECT *
		FROM `users` as u
		WHERE u.`email_address` = `email`) THEN
		INSERT INTO `places` (`place_name`, `user_email`)
		VALUES (`name_in`, `email`);
	END IF;
	END //

/*
	remove a place with given id
	@param id the id of the place to delete
*/
CREATE PROCEDURE remove_place(IN `place` int(32))
	BEGIN
	IF EXISTS(SELECT *
		FROM `places` as p
		WHERE p.`place_id` = `place`) THEN
		DELETE FROM `places`
		WHERE `place_id` = `place`;
	END IF;
	END //

/*
	create an address
	@param street1_in line 1 of street for address
	@param street2_in line 2 of street for address
	@param city_in the city of the address
	@param state_in the state of the address
	@param country_in the country of the address
	@param zip_in the zip code of the address
*/
CREATE PROCEDURE create_address(IN `street1_in` varchar(32), IN `street2_in` varchar(32), IN `city_in` varchar(32), IN `state_in` varchar(32), IN `country_in` varchar(32), IN `zip_in` varchar(32))
	BEGIN
	INSERT INTO `addresses` (`street_line_1`, `street_line_2`, `city`, `state`, `country`, `zip`)
	VALUES (`street1_in`, `street2_in`, `city_in`, `state_in`, `country_in`, `zip_in`);
	END //


/*
	remove an address with the given id
	@param id the id of the address being removed
*/
CREATE PROCEDURE remove_address(IN `id` int(32))
	BEGIN
	IF EXISTS(SELECT *
		FROM `addresses` as a
		WHERE a.`address_id` = `id`) THEN
	DELETE FROM `addresses`
	WHERE `address_id` = `id`;
	END IF;
	END //

/*
	set the address of a place to the address with the given id
	@param addr_id the id of the address being set as the address of a place
	@param place the id of the place that is having its address set
*/
CREATE PROCEDURE set_address(IN `place` int(32), IN `address` int(32))
	BEGIN
	IF EXISTS (SELECT *
		FROM `places` as p
		WHERE p.`place_id` = `place`)
	AND IF EXISTS (SELECT *
		FROM `addresses` as a
		WHERE a.`address_id` = `address`) THEN
	UPDATE `places`
	SET `address_id` = `address`
	WHERE `place_id` = `place`;
	END IF;
	END //



DELIMITER ;