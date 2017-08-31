/*
	stored procedures for the data records table
*/

DELIMITER //


/*
	create a new data record
	@param device the id of the device the record is for
	@param liter_val the value of the liters data record attribute
*/
CREATE PROCEDURE create_record(IN `device` int(32), IN `liter_val` int(32))
	BEGIN
	IF EXISTS (SELECT *
			FROM `devices` as d
			WHERE d.`device_id` = `device`) THEN
		INSERT INTO `data_records` (`record_liters`, `device_id`)
		VALUES (`liter_val`, `device`);
	END IF;
	END //

/*
	get a list of data records from a given device
	@param device the device id of the device that is being searched for data records
*/
CREATE PROCEDURE get_records_by_device(IN `device` int(32))
	BEGIN 
	IF EXISTS (SELECT *
			FROM `devices` as d
			WHERE d.`device_id` = `device`) THEN
		SELECT *
		FROM `data_records` as dr
		WHERE dr.`device_id` = `device`;
	END IF;
	END //

/*
	get a data record given the data record id
	@param id the data record's id
*/
CREATE PROCEDURE get_record(IN `id` int(32))
	BEGIN
	SELECT *
		FROM `data_records` as dr
		WHERE dr.`record_id` = `id`;
	END //


DELIMITER ;