/**
 * Created by Carlos on 8/31/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	let session_id = req.params.session_id;
	let place_name = req.params.place_id;

	if(!session_id || !place_name) // || !place_description || !address_id)
		return res.send(412, 'Precondition Failed');

	connection.query(`CALL get_email_from_session_id('${req.params.session_id}')`, (err, results, fields) =>{
		if(err) return res.send(404, 'Not Found');

		connection.query(`CALL create_device('${results[0][0].email_address}', '${place_name}')`, (err, results, fields) =>{
			if(err) return res.send(404, 'Not Found');
			res.send(201, 'Created');
		});
	});
});

module.exports = router;