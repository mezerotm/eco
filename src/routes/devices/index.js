/**
 * Created by Carlos on 6/28/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const hash = require('sjcl');
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	res.send('/devices');
});

module.exports = router;
