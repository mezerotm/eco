/**
 * Created by Carlos on 6/29/2017.
 */
const mysql = require('mysql');
const connection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: 'password',
	database: 'eco'
});

connection.connect((err) =>{
	if(err)
		console.error(`error connecting: ${err}`);
});

module.exports = connection;