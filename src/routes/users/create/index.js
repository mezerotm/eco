/**
 * Created by Carlos on 6/29/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const sjcl = require('sjcl');
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	let email_address = req.params.email_address;
	let password = req.params.password;
	let fname = req.params.fname;
	let lname = req.params.lname;

	if(!email_address || !password || !fname || !lname)
		return res.send(412, 'Precondition Failed');

	connection.query(`CALL create_user('${email_address}', '${fname}', '${lname}')`, (err, results, fields) =>{
        if(err) return res.send(404, 'Not Found');

		connection.query(`CALL set_password('${email_address}', '${password}')`, (err, results, fields) =>{
            if(err) return res.send(404, 'Not Found');
        });

		let session_id = sjcl.hash.sha256.hash(new Date().getTime());
		session_id = sjcl.codec.hex.fromBits(session_id);

		connection.query(`CALL set_session_id('${email_address}', '${session_id}')`, (err, results, fields) =>{
            if(err) return res.send(404, 'Not Found');
        });

		res.json({
			session_id: session_id
		});
    });
});

module.exports = router;
