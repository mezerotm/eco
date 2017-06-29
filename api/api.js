/**
 * Created by Carlos on 6/28/2017.
 */
const restify = require('restify');
const fs = require('fs');

const server = restify.createServer({
	name: "eco"
});

(function recursivelyApplyRoutes(dir){
	let absoluteRoutesPath = process.cwd() + '/routes' + (dir? dir:'');

	fs.readdirSync(absoluteRoutesPath).forEach((file) =>{
		let absoluteCurrentFilePath = absoluteRoutesPath + '/' + file;
		let isDirectory = fs.statSync(absoluteCurrentFilePath).isDirectory();

		if(isDirectory) recursivelyApplyRoutes((dir? dir:'') + '/' + file);
		if(file.indexOf('index.js') !== -1) require(absoluteCurrentFilePath).applyRoutes(server, dir);
	});
})();

server.listen(process.env.PORT || 3000, (err) =>{
	if(err) console.log(err);
	else console.log('%s listening at %s', server.name, server.url);
});