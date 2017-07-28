/**
 * Created by Carlos on 6/28/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const sjcl = require('sjcl');
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	//todo: refactor all these params variables into an object so that you can loop through a potentially LARGE list
	let session_id = req.params.session_id;
	let email_address = req.params.email_address === 'true';
	let fname = req.params.fname === 'true';
	let lname = req.params.lname === 'true';
	let created_datetime = req.params.created_datetime === 'true';
	let last_modified = req.params.last_modified === 'true';

	if(!session_id)
		return res.send(412, 'Precondition Failed');

	connection.query(`CALL get_email_from_session_id('${session_id}')`, (err, results, fields) =>{
		if(err) return res.send(404, 'Not Found');

		connection.query(`CALL get_user('${results[0][0].email_address}')`, (err, results, fields) =>{
			if(err) return res.send(404, 'Not Found');

			if(!email_address && !fname && !lname && !created_datetime && !last_modified)
				email_address = fname = lname = created_datetime = last_modified = true;

			let user = {};

			if(email_address) user.email_address = results[0][0].email_address;
			if(fname) user.fname = results[0][0].fname;
			if(lname) user.lname = results[0][0].lname;
			if(created_datetime) user.created_datetime = results[0][0].created_datetime;
			if(last_modified) user.last_modified = results[0][0].last_modified;

			res.json(user);

		});
	});
});

module.exports = router;
