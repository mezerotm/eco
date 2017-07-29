/**
 * Created by Carlos on 6/28/2017.
 */
const restify = require('restify');
const fs = require('fs');

const server = restify.createServer({
	name: "eco"
});

server.use(restify.plugins.queryParser({
	mapParams: true
}));

function recursivelyApplyRoutes(route){
	(function recurse(dir){
		let absoluteRoutesPath = __dirname + route + (dir? dir:'');

		fs.readdirSync(absoluteRoutesPath).forEach((file) =>{
			let absoluteCurrentFilePath = absoluteRoutesPath + '/' + file;
			let isDirectory = fs.statSync(absoluteCurrentFilePath).isDirectory();

			if(isDirectory) recurse((dir? dir:'') + '/' + file);
			if(file.indexOf('index.js') !== -1) require(absoluteCurrentFilePath).applyRoutes(server, dir);
		});
	})();
}
recursivelyApplyRoutes('/src/routes');

server.listen(process.env.PORT || 80, err =>{
	if(err) console.log(err);
	else console.log('%s listening at %s', server.name, server.url);
});