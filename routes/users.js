var express = require('express');
var router = express.Router();
var connection = require('../db/db.js');
var UserModels = require("../db/User_database_model.js");
var locationDetails = require('../models/cg_location.js');
var DbMethod = require('../models/DbModel.js');
var Secret = require('../secret/Secret.js');
var TokenValidate = require('../secret/TokenValidate.js');
var jwt=require('jsonwebtoken');
connection.connect(function(err) {
    if (err) {
        console.error('error connecting: ' + err.stack);
        return;
    }
    console.log('connected as id ' + connection.threadId);
});
//router.get('/locationDetails',Secret.verifyToken, function(req, res, next) {
router.get('/locationDetails',Secret.verifyToken,TokenValidate.MatchToken, function(req, res, next) {
    locationDetails.loctionSpend('',function(err,result){
        if(err){
            return res.json({
                result : err,
                error : true
            })
        }else{
            var length_data=Object.keys(result).length;
            var location=[];
            for(var i=0;i<length_data;i++){
               // console.log(result[0]['location']);
                location.push({
                    locationid : result[0]['locid'],
                    locationname: result[0]['location']
                });
            }
            return res.json({
            result : location,
            error : false
            })
        }

    });



});

router.delete('/', function(req, res, next) {
    res.status(200).json({message:'delete'});

});
/* GET users listing. */
router.get('/',Secret.verifyToken,(req, res, next) => {
    jwt.verify(req.token,Secret.secretkey,(err,authData)=>{
        if(err){
            return res.json({
                result : 'Token Expired or Empty',
                error : true
            })
        }else{
                UserModels.TokenCheck(req.token,function(err,rows){
                    if(err){
                        return res.json({
                            result : 'Issue in Token Matching',
                            error : true
                        })
                    }else{
                        var length_data=Object.keys(rows).length;
                        if(length_data>0){
                            var queryString ='SELECT * FROM user limit 2';
                            //var queryString='CALL nodecall()';
                            connection.query(queryString, function (err, rows, fields) {
                                if (err){
                                    return res.json({
                                            result :'Error',
                                            error : true
                                    })
                                }else{
                                    return res.json({
                                            result :rows,
                                            error : false
                                    })
                                }
                            });
                        }else{
                            return res.json({
                                result :'Token Mismatch',
                                error : false
                            })
                        }
                    }
                });
        }
    });
});
/*Get the user login*/
router.post('/login',function(req,res,next){
  //console.log(req.body.password);
  //
    if(req.body.username!='' && req.body.password!=''){
        //console.log(req.body.password);return false;
        UserModels.userCheck(req.body.username,req.body.password,function(rows,err){
            if(err)
            {
                return res.json({
                    result :'User Not Found',
                    error : true
                })
            }
            else{
                var length_data=Object.keys(rows).length;
                if(length_data>0){
                    jwt.sign({user:rows},Secret.secretkey,{expiresIn: '15m'},(err,token)=>{
                        if(err){
                            return res.json({
                            result :'Token Issue',
                            error : true
                            })
                        }else{
                            UserModels.TokenDelete(req.body.username,token,function(err,rows){
                                if(err){
                                    return res.json({
                                        result :err,
                                        error : true
                                    })
                                }else{
                                    UserModels.TokenInsert(req.param('username'),token,function(err,rows){
                                        if(err){
                                            return res.json({
                                                result :"Token Insert Issue",
                                                error : true
                                            })
                                        }else{
                                            return res.json({
                                                result :token,
                                                error : false
                                            })
                                        }
                                    });
                                }
                            });

                        }
                    });
                }else{
                    return res.json({
                        result :'User Not Found',
                        error : true
                    })
                }
            }
        });
    }else{
	return res.json({
		result :'Please enter username or password',
		error : true
	})
    }
});
router.post('/logout',function(req,res,next){
    if(req.body.userid!=''){
      //console.log(req.body.userid);return false;
        UserModels.TokenResetLogout(req.body.userid,function(err,rows){
            if(err){
                return res.json({
                    result :'Issue with logout or Reset',
                    error : true
                });
            }else{
                return res.json({
                    result :'Sucessfully Logout or Reset',
                    error : true
                });
            }
        });
    }else{
        return res.json({
        result :'Please pass userid',
        error : true
    })
    }
});
router.post('/reset',function(req,res,next){
    if(req.param('userid')!=''){
        UserModels.TokenResetLogout(req.param('userid'),function(err,rows){
            if(err){
                return res.json({
                    result :'Issue with logout or Reset',
                    error : true
                });
            }else{
                return res.json({
                    result :'Sucessfully Logout or Reset',
                    error : true
                });
            }
        });
    }else{
        return res.json({
        result :'Please pass userid',
        error : true
    })
    }
});
router.get('/overview_pull',function(req, response, next){
  DbMethod.OverviewPull(function(err,res){
      if(err){
        return response.json({
            errorstatus:true,
            result : err
        })
      }else{
        return response.json({
            errorstatus:false,
            result : res
        })
      }
  });
});
module.exports = router;
