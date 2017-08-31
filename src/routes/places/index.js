/**
 * Created by Carlos on 7/30/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	if(!req.params.session_id)
		return res.send(421, "Precondition Failed");

	connection.query(`CALL get_email_from_session_id('${req.params.session_id}')`, (err, results, fields) =>{
		if(err) return res.send(404, "Not Found");

		connection.query(`CALL get_places_from_user('${results[0][0].email_address}')`, (err, results, fields) =>{
			if(err) return res.send(404, "Not Found");

			let places = {};

			if(req.params['place_id'] === 'only'){
				places.place_id = [];
				for(let key in results[0]){
					places.place_id.push(results[0][key].place_id);
				}
				res.json(places.place_id);
			}else{
				(function(){
					return new Promise((resolve) =>{
						let resultsLength = Object.keys(results[0]).length;
						let resultsIndex = 1;

						for(let key in results[0]){
							connection.query(`CALL get_place('${results[0][key].place_id}')`, (err, results, fields) =>{
								if(err) return res.send(404, "Not Found");

								places[results[0][0].place_id] = {};

								if(Object.keys(req.params).length > 1){
									for(let key in req.params){
										if(key === 'session_id' || key === 'place_id') continue;
										if(req.params[key] === 'true')
											places[results[0][0].place_id][key] = results[0][0][key];
									}
								}else{
									for(let key in results[0][0]){
										if(key === 'place_id') continue;
										places[results[0][0].place_id][key] = results[0][0][key];
									}
								}

								if(resultsIndex++ === resultsLength)
									resolve(places);
							});
						}
					})
				})().then((places) =>{
					res.json(places);
				}).catch((err) =>{
					console.error(err);
				});
			}
		});
	});
});

module.exports = router;