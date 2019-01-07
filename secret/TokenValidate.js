var jwt=require('jsonwebtoken');
var Secret = require('../secret/Secret.js');
var UserModels = require("../db/User_database_model.js");
function TokenValidate(){}

TokenValidate.prototype.MatchToken = function(req,res,next){
  jwt.verify(req.token,Secret.secretkey,(err,authData)=>{
        if(err){
            return res.json({
                result : 'Token Expired or Empty',
                error : true
            });
        }else{
           UserModels.TokenCheck(req.token,function(err,rows){
               if(err){
                    return res.json({
                        result : rows,
                        error : true
                    })
                }else{
                    next();
                }
           })
        }
  });
}
module.exports = new TokenValidate();
