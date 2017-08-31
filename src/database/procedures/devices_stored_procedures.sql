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
	END IF;
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
	END IF;
	END //

/*
	get an individual device based on the device_id
	@param id the id of the device being retrieved
*/
CREATE PROCEDURE get_device(IN `id` int(32))
	BEGIN
	IF EXISTS (SELECT *
				FROM `devices` as d
				WHERE d.`device_id` = `id`) THEN
		SELECT *
		FROM `devices` as d
		WHERE d.`device_id` = `id`;
	END IF;
	END //

/*
	get an individual device group based on group id
	@param id the group id of the device group being retrieved
*/
CREATE PROCEDURE get_device_group(IN `id` int(32))
	BEGIN
	SELECT *
	FROM `device_groups` as d
	WHERE `group_id` = `id`;
	END //

/*
	get the device id's of all devices within a device group
	@param id the device group id
*/
CREATE PROCEDURE get_devices_in_group(IN `group_id` int(32))
	BEGIN
	SELECT `device_id`
		FROM `device_group_members` as m
		INNER JOIN `device_groups` as g
		ON m.`group_id` = g.`group_id`
		WHERE g.`group_id` = `group_id`;
	END //

/*
	get all device groups given a place
	@param place_id the id of the place the groups are within
*/
CREATE PROCEDURE get_device_groups_in_place(IN `place_id` int(32))
	BEGIN
	SELECT *
		FROM `device_groups` as g
		WHERE g.`place_id` = `place_id`;
	END //

/*
	add a device to a group
	@param group_id the id of the group the device is being added to
	@param device_id the id of the device being added
*/
CREATE PROCEDURE add_device_to_group(IN `group_id_in` int(32), IN `device_id_in` int(32))
	BEGIN

	IF EXISTS (SELECT *
		FROM `device_groups` as g
		WHERE g.`group_id` = `group_id_in`)
	AND EXISTS (SELECT *
		FROM `devices` as d
		WHERE d.`device_id` = `device_id_in`) THEN
	INSERT INTO `device_group_members` (`device_id`, `group_id`)
	VALUES (`device_id_in`, `group_id_in`);
	END IF;
	END //


/*
	remove a device
	@param id the id of the device being removed
*/
CREATE PROCEDURE remove_device(IN `id` int(32))
	BEGIN

	IF EXISTS (SELECT *
		FROM `devices` as d
		WHERE d.`device_id` = `device_id`) THEN
	DELETE FROM `devices`
	WHERE `device_id` = `id`;
	END IF;

	END //


/*
	remove a device from a group
	@param dev_id the device id of the device to be removed from the group
	@param group_id_in the group id of the group to remove the device from
*/
CREATE PROCEDURE remove_device_from_groups(IN `dev_id` int(32), IN `group_id_in` int(32))
	BEGIN
	IF EXISTS(SELECT *
		FROM `device_group_members`
		WHERE `device_id` = `dev_id` AND `group_id` = `group_id_in`) THEN
	DELETE FROM `device_group_members`
	WHERE `device_id` = `dev_id` AND `group_id` = `group_id_in`;
	END IF;
	END //

/*
	delete a device group
	@param id the id of the group to delete
*/
CREATE PROCEDURE remove_device_group(IN `id` int(32))
	BEGIN
	IF EXISTS(SELECT *
		FROM `device_groups`
		WHERE `group_id` = `id`) THEN
	DELETE FROM `device_group_members`
	WHERE `group_id` = `id`;
	DELETE FROM `device_groups`
	WHERE `group_id` = `id`;
	END IF;
	END //

/*
	update the arduino's mac address for a device
	@param dev_id the id of the device being modified
	@param new_mac the new mac address for the device
*/
CREATE PROCEDURE update_device_sensor_id(IN `dev_id` int(32), IN `new_mac` varchar(48))
	BEGIN
	IF EXISTS (SELECT *
		FROM `devices` as d
		WHERE d.`device_id` = `dev_id`) THEN
	UPDATE `devices`
	SET `device_sensors_id` = `new_mac`
	WHERE `device_id` = `dev_id`;
	END IF;
	END //


DELIMITER ;