/**
 * Created by Carlos on 6/29/2017.
 */
const mysql = require('mysql');
const connection = mysql.createConnection({
	host: 'us-cdbr-iron-east-05.cleardb.net',
	user: 'b74060db1ae5a3',
	password: '2362c679',
	database: 'heroku_0367e03a8c5429a'
});

connection.connect((err) =>{
	if(err) return console.error(`error connecting: ${err}`);
	console.log('connected database at 3306');
});

module.exports = connection;