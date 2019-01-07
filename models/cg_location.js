var connection = require('../db/db.js');

var LOCATION={
	loctionSpend:function(Token,callback){
		return connection.query("Select a.location,a.locid from table a limit 10 ",callback);
	}

};
module.exports=LOCATION;
