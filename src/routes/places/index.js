/**
 * Created by Carlos on 7/30/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	if(!req.params.session_id) 
		return res.send(421, "Precondition Failed");
	
	connection.query(`CALL get_email_from_session_id('${req.params.session_id}')`, (err, results, fields) => {
		if(err) return res.send(404, "Not Found");
		
		connection.query(`CALL get_place_from_user('${results[0][0].email_address}')`, (err, results, fields) => {
			if(err) return res.send(404, "Not Found");

			if(req.params['place_id'] === 'only')
				res.json({
					place_id: results[0][0]
				});
				
				
			let places = {};
			
			for(let place_id in results[0][0]) {
				connection.query(`CALL get_place('${place_id}')`, (err, results, fields) => {
					if(err) return res.send(404, "Not Found");
					
					for(let key in req.params) {
						if(key === 'session_id') continue;
						if(req.params[key] === 'true')
							places[key] = req.params[key];
					}
				});
			}
			
			res.json(places);
		});
	});
});

module.exports = router;