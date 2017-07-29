/**
 * Created by Carlos on 6/29/2017.
 */
const Router = require('restify-router').Router;
const router = new Router();
const connection = require(process.cwd() + '/src/database/connect.js');

router.get('/', (req, res, next) =>{
	let email_address = req.params.email_address;
	let password = req.params.password;
	let fname = req.params.fname;
	let lname = req.params.lname;

	if(!email_address || !fname || !lname)
		return res.send(412, 'Precondition Failed');

    connection.query(`CALL create_users('${email_address}','${fname}','${lname}'`, (err, results, fields) => {
        if(err) return res.send(404, 'Not Found');
        
        connectoin.query(`CALL set_password('${email_address}','${password}'`, (err, results, fields) => {
            if(err) return res.send(404, 'Not Found');
        });
        
        connectoin.query(`CALL set_session_id('${email_address}'`, (err, results, fields) => {
            if(err) return res.send(404, 'Not Found');
        });
    });
});

module.exports = router;
