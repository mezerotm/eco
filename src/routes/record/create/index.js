const Router = require('restify-router').Router;
const router = new Router();
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) => {
	let device_id = req.params.device_id;
	let liter_val = req.params.liter_val;

	if(!device_id || !data)
		return res.send(412, 'Precondition Failed');

	connection.query(`CALL create_record('${device_id}', '${liter_val}')`, (err, results, fields) => {
		if(err) return res.send(404, 'Not Found');
		return res.send(201, 'Created');
	});
});

module.exports = router;