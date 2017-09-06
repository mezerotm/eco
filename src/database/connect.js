/**
 * Created by Carlos on 6/29/2017.
 */
const mysql = require('mysql');
const connection = mysql.createPool({
	host: 'us-cdbr-iron-east-05.cleardb.net',
	user: 'b74060db1ae5a3',
	password: '2362c679',
	database: 'heroku_0367e03a8c5429a'
});

module.exports = connection;