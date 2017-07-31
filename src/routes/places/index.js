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

		connection.query(`CALL get_places_from_user('${results[0][0].email_address}')`, (err, results, fields) =>{
			if(err) return res.send(404, "Not Found");

			let places = {};
			let size = 0;

			if(req.params['place_id'] === 'only'){
				places.place_id = [];
				for(let key in results[0])
					places.place_id.push(results[0][size++].place_id);
				res.json(places.place_id);
			}

			(function get_places(){
				return new Promise((resolve, reject) =>{
					results[0].forEach((key) =>{
						connection.query(`CALL get_place('${results[0][size++].place_id}')`, (err, results, fields) =>{
							if(err) return res.send(404, "Not Found");

							places[results[0][0].place_id] = {};

							for(let key in req.params){
								if(key === 'session_id' || key === 'place_id') continue;
								if(req.params[key] === 'true')
									places[results[0][0].place_id][key] = results[0][0][key];
							}

							resolve(places);
						});
					});
				});
			})().then((places) =>{
				res.json(places);
			});


		});
	});
});

module.exports = router;