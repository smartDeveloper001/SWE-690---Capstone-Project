
var express 	= require('express');
var app         = express();
var bodyParser  = require('body-parser');
var morgan      = require('morgan');
const multer    = require('multer');
var session     = require('express-session');

var jwt         = require('jsonwebtoken');
var Model       = require('./app/models/index');
var config      = require('./conf/config');



const cors      = require('cors');
const fs        = require('fs');
var path        = require('path')
var redis_client= require('./lib/redis_client');

const { check } = require('express-validator/check');
const NodeCache = require( "node-cache" );
// const myCache = new NodeCache();

var port = process.env.PORT || 19090;

app.set('superSecret', config.secret);
app.use(session({secret: '51alp',name:'51alpc'}));

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());







var progressStream = require('progress-stream');

var storage = multer.diskStorage(
  {
      destination: './uploads/',
      filename: function ( req, file, cb ) {
		  cb( null, file.originalname);
      }
  }
);


const upload = multer({
  storage: storage
});



app.use(cors())


app.use(express.static('website'));


app.get('/', (req, res) => {
  res.sendFile(__dirname + 'index.html');
});


// redis_client.getValue("language").then(function(res){
//     console.log("get redis data :"+res)
// }, function(error) {
//     console.error('err', error);
// })

app.use(morgan('dev'));

// [
// 	check('password')
// 	  .isLength({ min: 5 }).withMessage('must be at least 5 chars long')
// 	  .matches(/\d/).withMessage('must contain a number')
//   ],


app.post('/user',function(req, res) {
	var newUser = req.body;

	Model.createUser(newUser).then(function process(result){
		res.json(result)

	})

});



app.get('/', (req, res) => {
	res.sendFile(__dirname + '/index.html');
  });



var auth = function(req, res, next) {
	console.log(req.path)

    if(req.path=='/login' || req.path=="/signup"){
		next()
	}else{

        token = req.get("token")
        console.log("auth token is:"+token)


        if(!token ){
            return res.json({ success: false, message: 'miss auth token in request head' });
        }
		redis_client.existKey(token).then(
            function(value){
				if (value ==1){
                    if (token) {
                        jwt.verify(token, app.get('superSecret'), function(err, decoded) {
                            if (err) {
                                return res.json({ success: false, message: 'Failed to authenticate token.' });
                            } else {
                                console.log("--------------pass auth--------------")
                                req.decoded = decoded;
                                next();
                            }
                        });
                    } else {
                        return res.status(403).send({
                            success: false,
                            message: 'No token provided.'
                        });
                    }

				}else{
                    return res.json({ success: false, message: 'you have logout before  please login again' });
				}
            }
        ).catch(function(error){
            console.log(error)
            return res.json({ success: false, message: error});

        })



	}

}







var apiRoutes = express.Router();


apiRoutes.use(auth)


apiRoutes.get('/logout', auth ,function(req,res){
	token = req.get("token")
	console.log("token is:"+token)
	if(token){
        redis_client.getValue(token).then(
            function(data){
            	console.log("value is:"+data)
                if(data){


                    redis_client.deletKey(token).then(
                        function(data){
                            res.json({ success: true, message: 'logout successfull' });
                        }
                    ).catch(function(error){
                        res.json({ success: false, message: 'logout fail' });
                    })



					// // delete user_email -> token too
					//
                    // redis_client.deletKey(data).then(
                    //     function(data){
                    //        console.log("successful delete data:"+data)
                    //     }
                    // ).catch(function(error){
                    //     console.log("fail delete data :"+data)
                    // })




                }else{
                    res.json({ success: false, message: 'logout fail with invalid token' })
				}
            }
        ).catch(function(error){
            //console.err("can not set value to redis error :"+err)
            res.json({ success: false, message: 'logout fail without invalid token' });
        })



	}else{
        res.json({ success: false, message: 'logout fail without token' });
	}

	})



apiRoutes.post('/signup',function(req, res) {
    var newUser = req.body;

	if(!newUser.user_name || !newUser.user_password||  !newUser.user_email){
        res.json({ success: false, message: 'user_name user_password user_email is required !' })
	}

    Model.createUser(newUser).then(function process(result){
        res.json(result)
    })
});




apiRoutes.get('/consultants', function(req, res) {

    Model.getConsultants().then(function process(result){
        res.json(result)
    })
});



apiRoutes.get('/parentConsultant/parent/:parentId', function(req, res) {
    var parentId = req.params.parentId;
    Model.getParentConsultantByParentId(parentId).then(function process(result){
    	if(result){
            res.json(result)
		}else{
    		res.json({})
		}

    })
});


apiRoutes.get('/parentConsultant/consultant/:consultantId', function(req, res) {
    var consultantId = req.params.consultantId;
	Model.getParentConsultantByConsultantId(consultantId).then(function process(result){
		res.json(result)
	})
});



apiRoutes.post('/parentConsultant', function(req, res) {
    var newParentConsultant= req.body;
    console.log(newParentConsultant)
    Model.createParentConsultant(newParentConsultant).then(function process(result){
        res.json(result)
    })
});

apiRoutes.put('/parentConsultant/:parentId/:status',function(req, res) {
    var parentId = req.params.parentId;
    var status = req.params.status;

    Model.updateParentConsultantStatus(parentId,status).then(function process(result){
        res.json(result)
    })
});











apiRoutes.post('/login', function(req, res) {
	Model.login(req.body).then(function process(result){
		if(result.success){
			var payload = {
				userEmail: req.body.user_email
			}
			var token = jwt.sign(payload, app.get('superSecret'), {
				expiresIn: '365d' // expires in 24 hours
			});
			req.session.token =  token
			req.session.userId = result.user._id

			result.token = token

			// myCache.set( token, result.user, function( err, success ){
			// 	if( !err && success ){
			// 	  console.log( "save token:"+token );
			// 	  console.log( "link to user :"+result.user );
			// 	}
			//   });

			redis_client.setValue(result.token,result.user.user_email).then(
                function(data){
					console.log("set value to redis  redis data :"+result.user.user_name)
				}

			).catch(function(err){
                console.err("can not set value to redis error :"+err)
			})

            // redis_client.setValue(result.user.user_email,result.token).then(
            //     function(data){
            //         console.log("set value to redis  redis data :"+result.token)
            //     }
			//
            // ).catch(function(err){
            //     console.err("can not set value to redis error :"+err)
            // })

		}
		res.json(result)
	}).catch(function rejectFuc(err){
		console.log(err)
	})

});




// apiRoutes.use(function(req, res, next) {

// 	var token  = req.session.token
// 	if(!token){
// 		return res.json({ success: false, message: 'you session is expired or logout please login again' });
// 	}

// 	var token = req.body.token || req.param('token') || req.headers['x-access-token'];
// 	if (token) {
// 		jwt.verify(token, app.get('superSecret'), function(err, decoded) {
// 			if (err) {
// 				return res.json({ success: false, message: 'Failed to authenticate token.' });
// 			} else {
// 				req.decoded = decoded;
// 				next();
// 			}
// 		});
// 	} else {
// 		return res.status(403).send({
// 			success: false,
// 			message: 'No token provided.'
// 		});
// 	}
// });



apiRoutes.post('/upload', function (req, res, next) {

	  // var progress = progressStream({length: '0'});
	  // req.pipe(progress);
	  // progress.headers = req.headers;
	  //
	  //
	  // progress.on('length', function nowIKnowMyLength (actualLength) {
		//   console.log('actualLength: %s', actualLength);
		//   progress.setLength(actualLength);
	  // });
	  //
	  //
	  // progress.on('progress', function (obj) {
		//   console.log('progress: %s', obj.percentage);
	  // });


	var token = req.get('token');
	if (token == undefined){
		return res.send({message:"you miss the token "});

	}

    redis_client.getValue(token).then(function(userEmail){

		console.log("get redis data :"+userEmail)

        if (userEmail != undefined ){
            var upload = multer({
                storage: multer.memoryStorage()
            }).single('file')

            upload(req, res, function(err) {

                var ext = path.extname(req.file.originalname)
                if (ext !== '.mp4') {
                    return res.send({message:"upload fail only mp4 file allow"});

                }
                var buffer = req.file.buffer
                var userpath = './uploads/' + userEmail
                !fs.existsSync(userpath) && fs.mkdirSync(userpath)
                //var disfileName = path.basename(req.file.originalname,".mp4") + '-' + Date.now() + path.extname(req.file.originalname)
                var disfileName = path.basename(req.file.originalname,".mp4") + path.extname(req.file.originalname)
                fs.writeFile( userpath + "/" + disfileName, buffer, 'binary', function(err) {
                    if (err){
                        throw err
                        return res.send({success:false,message:"upload fail error "+err})
                    }
                    return res.send({success:true,message:"/video/"+userEmail + "/" + disfileName});
                })

            })



        }else{
            console.log({success:false,message:"please login firstly",error:"no Token"})
            res.end()
        }




	}, function(error) {


		console.error('err', error);
	})


})

    apiRoutes.post('/uploadImage', function (req, res, next) {
        var token = req.get('token');
        if (token == undefined){
            return res.send({message:"you miss the token "});

        }

        redis_client.getValue(token).then(function(userEmail){

            console.log("get redis data :"+userEmail)

            if (userEmail != undefined ){
                var upload = multer({
                    storage: multer.memoryStorage()
                }).single('file')

                upload(req, res, function(err) {

                    var ext = path.extname(req.file.originalname)
                    if (ext !== '.jpg') {
                        return res.send({message:"upload fail only png file allow"});

                    }
                    var buffer = req.file.buffer
                    var userpath = './uploads/' + userEmail
                    !fs.existsSync(userpath) && fs.mkdirSync(userpath)
                    //var disfileName = path.basename(req.file.originalname,".mp4") + '-' + Date.now() + path.extname(req.file.originalname)
                    var disfileName = path.basename(req.file.originalname,".jpg") + path.extname(req.file.originalname)
                    fs.writeFile( userpath + "/" + disfileName, buffer, 'binary', function(err) {
                        if (err){
                            throw err
                            return res.send({success:false,message:"upload fail error "+err})
                        }
                        Model.addAvataToUser(userEmail,"/image/"+userEmail + "/" + disfileName)
                        return res.send({success:true,message:"/image/"+userEmail + "/" + disfileName});
                    })

                })



            }else{
                console.log({success:false,message:"please login firstly",error:"no Token"})
                res.end()
            }




        }, function(error) {


            console.error('err', error);
        })


    })


        // myCache.get( token, function( err, value ){
	// 	if( !err ){
	// 	  if(value == undefined){
	// 		return res.send({message:"your token is expired and you need login again to upload  "});
	// 	  }else{
	// 		console.log(token)
	// 		console.log(value)
	// 		var user_id  = value._id
	// 		console.log(user_id)
	// 		if (user_id != undefined ){
	// 			var upload = multer({
	// 				storage: multer.memoryStorage()
	// 			}).single('file')
	//
	// 			upload(req, res, function(err) {
	//
	// 			var ext = path.extname(req.file.originalname)
	// 			if (ext !== '.mp4') {
	// 				return res.send({message:"upload fail only mp4 file allow"});
	//
	// 			}
	// 			var buffer = req.file.buffer
	// 			var userpath = './uploads/' + user_id
	// 			!fs.existsSync(userpath) && fs.mkdirSync(userpath)
	// 			var disfileName = path.basename(req.file.originalname,".mp4") + '-' + Date.now() + path.extname(req.file.originalname)
	// 				fs.writeFile( userpath + "/" + disfileName, buffer, 'binary', function(err) {
	// 					if (err){
	// 						throw err
	// 						return res.send({messageCode:500,message:"upload fail",error:err})
	// 					}
	// 					return res.send({messageCode:200,message:"upload successful",storeFileName: user_id + "/" + disfileName});
	// 				})
	//
	// 			})
	//
	// 		}else{
	// 			console.log("user id is empty internal error need check log")
	// 			res.end()
	// 		}
	//
	//
	//
	// 	  }
	// 	}
	//   });




		// fileFilter: function(req, file, callback) {
		// 	var ext = path.extname(file.originalname)
		// 	console.log(ext)
		// 	if (ext !== '.mp4') {
		// 		console.log("callback")
		// 		return callback(res.end('Only mp4 are allowed'), false)
		// 	}
		// 	callback(null, true)
		// }









app.get('/video/:userEmail/:fileName', async (req, res) => {
	var filePath = "./uploads/";
	var fileName = req.params.fileName;
    var userEmail = req.params.userEmail;

	res.download(filePath+userEmail+"/"+fileName, function(err){
	  if (err) {
		console.log(err)
		return res.end("can not find thie file :"+fileName)
	  } else {
		console.log("download successfullly")
	  }
	});
	console.log("download end")
  })

app.get('/image/:userEmail/:fileName', async (req, res) => {
	var filePath = "./uploads/";
	var fileName = req.params.fileName;
	var userEmail = req.params.userEmail;

	res.download(filePath+userEmail+"/"+fileName, function(err){
		if (err) {
			console.log(err)
			return res.end("can not find thie file :"+fileName)
		} else {
			console.log("download successfullly")
		}
	});
	console.log("download end")
})



apiRoutes.get('/', function(req, res) {
	console.log("token in session:"+req.session.token)
	console.log("req.session.view:"+req.session.view)

	res.json({ message: 'Welcome to the 51alp backend API!' });
});

apiRoutes.get('/user/:id', function(req, res) {
	Model.getUserById(req.params.id).then(function proc(result){
		res.json(result)
	})
});


apiRoutes.get('/users/consultant/:consultantId', function(req, res) {
    Model.getUsersAssociatedConsultantId(req.params.consultantId).then(function proc(result){
        res.json(result)
    })
});

apiRoutes.get('/users/parent/:parentId', function(req, res) {
    Model.getUsersAssociatedParentId(req.params.parentId).then(function proc(result){
        res.json(result)
    })
});








apiRoutes.put('/user', function(req, res) {
	console.log(req.body)
    Model.updateUser(req.body).then(function proc(result){
        console.log(result)
        res.json(result)
    }).catch(function process(err){
        console.log(error)
    })
});


apiRoutes.put('/user/:userId/:oldPassword/:newpassord', function(req, res) {
    console.log(req.body)
    Model.changePassword(req.params.userId,req.params.oldPassword,req.params.newpassord).then(function proc(result){
        console.log(result)
        res.json(result)
    }).catch(function process(err){
        console.log(error)
    })
});




apiRoutes.post('/course', function(req, res) {
	// console.log("comming.."+JSON.stringify(req.body))
	Model.createCourse(req.body).then(function proc(result){
		console.log(result)
		res.json(result)
	}).catch(function process(err){
		console.log(error)
	})
});

apiRoutes.put('/course', function(req, res) {
	// console.log("comming.."+JSON.stringify(req.body))
	Model.updateCourse(req.body).then(function proc(result){
		console.log(result)
		res.json(result)
	}).catch(function process(err){
		console.log(error)
	})
});

apiRoutes.delete('/course/:id', function(req, res) {
	// console.log("comming.."+JSON.stringify(req.body))
	Model.deleteCourse( req.params.id).then(function proc(result){
		console.log(result)
		res.json(result)
	}).catch(function process(err){
		console.log(error)
	})
});


apiRoutes.get('/courses', function(req, res) {
	Model.getAllCourse(req.body).then(function proc(result){
		res.json(result)
	}).catch(function process(err){
        console.log(error)
    })
});



apiRoutes.post('/gogal', function(req, res) {
	console.log("comming.."+JSON.stringify(req.body))
	Model.createGogal(req.body)
	.then(function proc(result){
		res.json(result)
	})
});

apiRoutes.get('/gogals', function(req, res) {
	Model.getAllGogal(req.body).then(function proc(result){
		res.json(result)
	})
});

apiRoutes.get('/gogals/:id', function(req, res) {
    Model.getAllGogalByCouarseId(req.params.id).then(function proc(result){
        res.json(result)
    })
});



apiRoutes.put('/gogal', function(req, res) {
	// console.log("comming.."+JSON.stringify(req.body))
	Model.updateGogal(req.body).then(function proc(result){
		console.log(result)
		res.json(result)
	}).catch(function process(err){
		console.log(error)
	})
});

apiRoutes.delete('/gogal/:id', function(req, res) {
	// console.log("comming.."+JSON.stringify(req.body))
	Model.deleteGogal( req.params.id).then(function proc(result){
		console.log(result)
		res.json(result)
	}).catch(function process(err){
		console.log(error)
	})
});


apiRoutes.put('/gogal/:gogalId/video', function(req, res) {
	console.log("comming gogalId:"+req.params.gogalId)
	console.log("comming body:"+JSON.stringify(req.body))
	Model.addVideoForGogal(req.params.gogalId,req.body).then(function proc(result){
		console.log(result)
		res.json(result)
	}).catch(function process(err){
		console.log(error)
	})
});


apiRoutes.delete('/gogal/:gogalId/:videoId', function(req, res) {
	console.log("delete video gogalId"+req.params.gogalId+"  videoId:"+req.params.videoId)
	Model.deleteVideoForGogal(req.params.gogalId,req.params.videoId).then(function proc(result){
		res.json(result)
	}).catch(function process(err){
		console.log(error)
        res.json(error)
	})
});



apiRoutes.post('/userTask', function(req, res) {
    console.log("request:"+req.body.user_id)
	Model.createUserTask(req.body).then(function proc(result){
		res.json(result)
	})
});

apiRoutes.put('/userTask/:taskId/:status', function(req, res) {
	Model.updateUserTaskStatus(req.params.taskId,req.params.status).then(function proc(result){
		res.json(result)
	})
});

apiRoutes.get('/userTask/:userId', function(req, res) {
	console.log("look up user task for id:"+req.params.userId)
	Model.getUserTaskByUserId(req.params.userId).then(function proc(result){
		res.json(result)
	})
});

apiRoutes.get('/task/:taskId', function(req, res) {
    console.log("look up  task for id:"+req.params.taskId)
    Model.getUserTaskById(req.params.taskId).then(function proc(result){
        res.json(result)
    })
});


apiRoutes.put('/userTask/:taskId', function(req, res) {
	console.log("look up user task for id:"+req.params.taskId)
	Model.addReplayForUserTask(req.params.taskId,req.body).then(function proc(result){
		res.json(result)
	})
});




apiRoutes.post('/gogalBreak', function(req, res) {
	console.log(req.body)
	Model.createGogalBreak(req.body).then(function proc(result){
		res.json(result)
	})
});

apiRoutes.put('/gogalBreak', function(req, res) {
	console.log(req.body)
	Model.updateGogalBreak(req.body).then(function proc(result){
		res.json(result)
	})
});



apiRoutes.get('/gogalBreaks/:userId', function(req, res) {
	Model.getGogalBreakByUserId(req.params.userId).then(function proc(result){
        if(result){

            res.json(result)
        }else{
            res.json({})
        }
	})
});

apiRoutes.get('/gogalBreaks', function(req, res) {
    Model.getAllGogalBreak().then(function proc(result){
        if(result){

            res.json(result)
        }else{
            res.json({})
        }
    })
});





apiRoutes.delete('/gogalBreak/:id', function(req, res) {
    // console.log("comming.."+JSON.stringify(req.body))
    Model.deleteGogalBreak( req.params.id).then(function proc(result){
        console.log(result)
        res.json(result)
    }).catch(function process(err){
        console.log(error)
    })
});

apiRoutes.post('/feedback', function(req, res) {
    Model.createUserFeedback(req.body).then(function proc(result){
        console.log(result)
        res.json(result)
    }).catch(function process(err){
        console.log(error)
    })
});



// apiRoutes.post('/gogalBreakDetail/:gogalId', function(req, res) {
//     console.log(req.body)
//     Model.addBreakForGogal(req.params.gogalId,req.body).then(function proc(result){
//         res.json(result)
//     }).catch(function process(err){
//         console.log(error)
//     })
// });
//
// apiRoutes.put('/gogalBreakDetail/:gogalId', function(req, res) {
//     console.log(req.body)
//     Model.updateaBreakForGogal(req.params.gogalId,req.body).then(function proc(result){
//         res.json(result)
//     })
// });
//
// apiRoutes.delete('/gogalBreakDetail/:gogalId', function(req, res) {
//     console.log(req.body)
//     Model.deleteBreakForGogal(req.params.gogalId,req.body.break_id).then(function proc(result){
//         res.json(result)
//     })
// });



// apiRoutes.post('/task/:gogalbreakId/:breaekId', function(req, res) {
//     console.log(req.body)
//     Model.addTaskForGogalBreak(req.params.gogalbreakId,req.params.breaekId,req.body).then(function proc(result){
//         res.json(result)
//     }).catch(function process(err){
//         console.log(error)
//     })
// });
//
// apiRoutes.put('/task/:gogalbreakId/:breakId', function(req, res) {
//     console.log(req.body)
//     Model.updateTaskForGogalBreak(req.params.gogalbreakId,req.params.breakId,req.body).then(function proc(result){
//         res.json(result)
//     }).catch(function process(err){
//         console.log(error)
//     })
// });


// apiRoutes.delete('/task/:gogalbreakId/:breaekId', function(req, res) {
//     console.log(req.body)
//     Model.deleteTaskForGogalBreak(req.params.gogalbreakId,req.params.breaekId,req.body.task_id).then(function proc(result){
//         res.json(result)
//     }).catch(function process(err){
//         console.log(error)
//     })
// });


apiRoutes.get('/cities', function(req, res) {
    Model.getAllCityInfo().then(function proc(result){
        res.json(result)
    })
});



app.use('/api', apiRoutes);


app.listen(port);
console.log('51alp server is  at http://localhost:' + port);
