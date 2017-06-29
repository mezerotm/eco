/**
 * Created by Carlos on 6/28/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();

router.get('/', (req, res, next) =>{
	res.send("Hello, World! - /arduino");
});

module.exports = router;
