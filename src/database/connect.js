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
	if(err) return console.error(`error connecting: ${err}`);
	console.log('connected database at 3306')
});

module.exports = connection;