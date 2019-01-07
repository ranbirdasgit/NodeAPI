var connection = require('./db.js');
var bcrypt = require('bcrypt');
var USER={
	userCheck:function(id,password,callback){

//console.log("Select id,name,email from apiuser where name='"+id+"' and password='"+password+"'");
            //console.log(id);
            //return connection.query("Select id,name,email from apiuser where name='"+id+"' and password='"+password+"'",callback);
          var query=  connection.query("Select id,username,email,password from apiuser where username='"+id+"'",function(err,res){
						//	console.log(query.sql);return false;
                var hash=res[0].password;
                bcrypt.compare(password,hash,function(err,response){
                    if(response===true){
                        callback(res,false);
                    }else{
                        console.log(err);
                       callback(err,true);
                    }
                })
            });
	},
	TokenInsert:function(id,token,callback){
		//connection.query("delete from apitoken where userid=?",[id],callback);
		connection.query("INSERT INTO apitoken(`userid`, `token`) values(?,?)",[id,token],callback);
	},
	TokenDelete:function(id,token,callback){

		connection.query("delete from apitoken where userid=?",[id],callback);


	},
        TokenCheck:function(token,callback){
					//console.log(token);return false;
		connection.query("select token from apitoken where token=?",[token],function(err,res){
                    if(err){
                        callback(true,'error to fetch token');
                    }else{
                        if(res.length>0){
                            callback(false,'Token match');
                        }else{
                            callback(true,'Token Mismatch');
                        }
                    }
                });

	},
        TokenResetLogout:function(userid,callback){
		var query=connection.query("delete from apitoken where userid=?",[userid],callback);
		console.log(query.sql);
	}
};
module.exports=USER;
