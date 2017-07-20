/**
 * Created by Carlos on 6/28/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const sjcl = require('sjcl');
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	let email_address = req.params.email_address;
	let password = req.params.password;

	if(!email_address || !password)
		return res.send(412, 'Precondition Failed');

	let isValidUser = true; // MySQL procedural statement : verify user
	if(isValidUser){
		let session_id = sjcl.hash.sha256.hash(new Date().getTime());
		session_id = sjcl.codec.hex.fromBits(session_id);
		// MySQL procedural statement : set session_id

		res.json({
			session_id: session_id
		});
	}else
		return res.send(401, 'Unauthorized');
});

module.exports = router;
