/*
	stored procedures for the devices table
*/

DELIMITER //

/*
	create a new device
	@param id the place_id of the place this device will be in
*/
CREATE PROCEDURE create_device(IN `id` int(32), IN `device_id` VARCHAR(64))
	BEGIN
	IF EXISTS (SELECT *
			FROM `places` p
			WHERE p.`place_id` = `id`) THEN
		INSERT INTO `devices` (`device_sensors_id`, `place_id`)
		VALUES (`device_id`, `id`);
	END //

/*
	get a list of all devices within a given place
	@param place the id of the place
*/
CREATE PROCEDURE get_devices_in_place(IN `place` int(32))
	BEGIN
	IF EXISTS (SELECT *
				FROM `places` as p
				WHERE p.`place_id` = `place`) THEN
		SELECT *
		FROM `devices` as d
		WHERE d.`place_id` = `place`;
	END //

/*
	get an individual device based on the device_id
*/
CREATE PROCEDURE get_device(IN `id` int(32))
	BEGIN
	IF EXISTS (SELECT *
				FROM `devices` as d
				WHERE d.`device_id` = `id`) THEN
		SELECT *
		FROM `devices` as d
		WHERE d.`device_id` = `id`;
	END //


DELIMITER ;