/**
 * Created by Carlos on 6/29/2017.
 */
const production = require('./production.js');
const mysql = require('mysql');

const connection = mysql.createPool({
	host: production.host,
	user: production.user,
	password: production.password,
	database: production.database
});

module.exports = connection;