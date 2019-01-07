/*var connection = require('./db.js');
var exports = module.exports = {};

exports.sayHelloInEnglish = function() {
  return "HELLO";
};

exports.sayHelloInSpanish = function() {
  return "ranbir das";
};
*/
//var ApiUrl = require('./ApiUrl.js');
function Secret(){}

Secret.prototype.verifyToken = function(req,res,next){
    const bearerHeader=req.headers['authorization'];
    if(typeof bearerHeader !=='undefined'){
        const bearer=bearerHeader.split(' ');
        const bearerToken=bearer[1];
        req.token=bearerToken;

          next();//-------comment below code for token that i created

        /*if(ApiUrl.GetSalesToken!=bearerToken){
            return res.json({
                result :'Token Mismatch',
                error : true
            })
        }else{
            next();
        }*/
    }else{
        return res.json({
            result :'Forbidden',
            error : true
        })
    }
}
Secret.prototype.secretkey='ranbir';
module.exports = new Secret();
