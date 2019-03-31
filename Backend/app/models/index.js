
var mongoose      = require('mongoose');
var Schema        = mongoose.Schema;
var timestamps    = require('mongoose-timestamp');
var bcrypt        = require('bcrypt');
var Promise       = require('es6-promise').Promise
var autoIncrement = require('mongoose-auto-increment');
var transfer      = require('../../lib/transfer');
var config        = require('../../conf/config');
const saltRounds  = 10;
const fs          = require('fs');
var path          = require('path')
mongoose.connect(config.database);
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    console.log("connect successfull")
});

autoIncrement.initialize(db);




var videoSchema = new Schema({
    video_type:String,
    video_name:String,
    video_path:String
});

videoSchema.plugin(timestamps);
videoSchema.plugin(autoIncrement.plugin, 'Video');
var Video = db.model('Video', videoSchema);



var courseSchema =  new Schema({
	course_level: Number,
	course_level_name: String,
	course_name: String,
	course_goal: String,
    course_syllabus: String,
    course_type:String
});

courseSchema.plugin(timestamps);
courseSchema.plugin(autoIncrement.plugin, 'Course');
var Course = db.model('Course', courseSchema);






var gogalSchema =  new Schema({
    course_id: Number,
	course_level: Number,
	course_level_name: String,
	course_name: String,
	course_goal: String,
    course_syllabus: String,
    course_type:String,
    goal_seq:Number,
    goal_name: String,
    goal_describ: String,
    goal_requirement: String,
    demo_video:[videoSchema]
},
{ usePushEach: true });

gogalSchema.plugin(timestamps);
gogalSchema.plugin(autoIncrement.plugin, 'Gogal');
var Gogal = db.model('Gogal', gogalSchema);

var parentConsultantSchema = new Schema({
    parent_id:Number,
    num_tasks_replay:Number , // need replay tasks number
    parent_name:String,
    parent_email:String,
    status:Number,  // 0  delete 1 activity 2 pending
    consultant_id:Number,
    num_tasks_handle:Number // need handle tasks number


});

parentConsultantSchema.plugin(timestamps);
parentConsultantSchema.plugin(autoIncrement.plugin, 'ParentConsultant');
var ParentConsultant = db.model('ParentConsultant', parentConsultantSchema);


var userSchema = new Schema({
    user_name: String,
    user_email: String,
    user_password: String,
    user_status: Number, // 0    1 activity  2 pending  (maybe need pay or need approve by admin)
    user_type: String,
    user_type_id: Number,  // 1 parent 2 consultant 3 admin
    user_state_code: Number,
    user_state: String,
    user_city: String,
    user_city_code: Number,
    user_self_introduce: String,
    user_avatar_path:String,
},
{ usePushEach: true }
);
userSchema.plugin(timestamps);
userSchema.plugin(autoIncrement.plugin, 'User');
var User = db.model('User', userSchema);


var replaySchema = new Schema({
    user_id:Number,
    replay_type:Number,  // 1 parent  2 consulant
    replay_title:String,
    replay_content:String,
    replay_vides:[videoSchema]
})
replaySchema.plugin(timestamps);
replaySchema.plugin(autoIncrement.plugin, 'Replay');
var Replay = db.model('Replay', replaySchema);


var userTaskSchema = new Schema({
    user_id: Number,
    consultant_id:Number,
    course_id:Number,
    goal_id:Number,
    goal_break_id:Number,
    task_title:String,
    task_content:String,
    task_status:Number,
    replays:[replaySchema]
    },
    { usePushEach: true }
)






userTaskSchema.plugin(timestamps);
userTaskSchema.plugin(autoIncrement.plugin, 'UserTask');
var UserTask = db.model('UserTask', userTaskSchema);

// var taskSchema = new Schema({
//        task_title:String,
//        task_content:String
//     }
// )
//
// taskSchema.plugin(timestamps);
// taskSchema.plugin(autoIncrement.plugin, 'Task');
// var Task = db.model('Task', taskSchema);

// var braekchema = new Schema({
//         break_title:String,
//         break_desc:String,
//         break_question:String,
//         break_requirement:String,
//         // tasks:[taskSchema],
//     },
//     { usePushEach: true }
// )
// braekchema.plugin(timestamps);
// braekchema.plugin(autoIncrement.plugin, 'Break');
// var Break = db.model('Break', braekchema);
//



var gogalBreakSchema = new Schema({
    user_id:Number,
    course_id:Number,
    goal_id:Number,
    break_title:String,
    break_desc:String,
    break_question:String,
    break_requirement:String,
    break_status:Number, // 1 activity 0 deleted
    },
    { usePushEach: true }
)

gogalBreakSchema.plugin(timestamps);
gogalBreakSchema.plugin(autoIncrement.plugin, 'GogalBreak');
var GogalBreak = db.model('GogalBreak', gogalBreakSchema);



var userFeedbackSchema = new Schema({
        user_id:Number,
        feedback:String,


    },
    { usePushEach: true }
)

userFeedbackSchema.plugin(timestamps);
userFeedbackSchema.plugin(autoIncrement.plugin, 'UserFeedback');
var UserFeedback = db.model('UserFeedback', userFeedbackSchema);



function createUserFeedback(obj){
    console.log("star createUserFeedback")
    return new Promise(function (resolve, reject){

        var UserFeedbackDB = new  UserFeedback(obj);
        UserFeedbackDB.save(function(err,userFeedback) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log('userFeedback  saved successfully')
            resolve(userFeedback);
        });
    });
}






function createUser(obj){
    return new Promise(function (resolve, reject) {
        var dbUser = new User(obj);
        User.findOne({
            user_email: obj.user_email
        }, function(err, user) {
            if (err) reject(err);
             if (user) {
                resolve({ success: false, message: 'User existed' });
            } else {
                dbUser.user_password =  bcrypt.hashSync(dbUser.user_password, saltRounds)
                 dbUser.user_status = 2
                 dbUser.save(function(err,user) {
                if (err) reject(err);
                console.log('User saved successfully');
                resolve({ success: true, message: 'User create successful',user:user });
                });
            }
            })
    });
}



function getUserById(id){
    return new Promise(function (resolve, reject) {
        User.findOne({
            _id: id
        }, function(err, user) {
            if (err) reject(err);
            if (!user) {
                console.log("can not foud user")
                resolve({ success: false, message: 'can not found user.' });
            } else if (user) {
                resolve({  success: true, user: user} );
            }

        })

    });
}



function getUserByname(userName){
    return new Promise(function (resolve, reject) {
        User.findOne({
            user_name: userName
        }, function(err, user) {
            if (err) reject(err);
            if (!user) {
                console.log("can not foud user")
                resolve({ success: false, message: 'can not found user.' });
            } else if (user) {
                resolve({  success: true, user: user} );
                }

        })

    });
}

function getConsultants(){
    return new Promise(function (resolve, reject) {
        User.find({
            user_type_id: 2
        }, function(err, users) {
            if (err) reject(err);
            resolve(users);

        })

    });
}



function getUserByUserEmail(userEmail){
    return new Promise(function (resolve, reject) {
        User.findOne({
            user_email: userEmail
        }, function(err, user) {
            if (err) reject(err);
            if (!user) {
                console.log("can not foud user")
                resolve({ success: false, message: 'can not found user.' });
            } else if (user) {
                resolve({  success: true, user: user} );
            }

        })

    });
}



function getUsersAssociatedConsultantId(consultant_id){
    return new Promise(function (resolve, reject) {




        ParentConsultant.find({
            consultant_id: consultant_id
        }, function(err, parentConsultants) {
            if (err) reject(err);

            var userIds = []
           // console.log(parentConsultants)

            for (var i = 0;i< parentConsultants.length;i++) {
               // console.log(parentConsultants[i])
                userIds.push(parentConsultants[i].parent_id)
            }
            userIds.push(consultant_id)
            console.log("associated user ids "+userIds)

            User.find({
                _id:{ $in: userIds }
            }, function(err, users) {
                if (err) reject(err);
                if (!users) {
                    console.log("can not foud user")
                    resolve({});
                } else if (users) {
                    resolve(users);
                }

            })

        })


    });
}

function getUsersAssociatedParentId(parent_id){
    return new Promise(function (resolve, reject) {




        ParentConsultant.find({
            parent_id: parent_id
        }, function(err, parentConsultants) {
            if (err) reject(err);

            var userIds = []
            // console.log(parentConsultants)

            for (var i = 0;i< parentConsultants.length;i++) {
                // console.log(parentConsultants[i])
                userIds.push(parentConsultants[i].consultant_id)
            }
            userIds.push(parent_id)
            console.log("associated user ids "+userIds)

            User.find({
                _id:{ $in: userIds }
            }, function(err, users) {
                if (err) reject(err);
                if (!users) {
                    console.log("can not foud user")
                    resolve({});
                } else if (users) {
                    resolve(users);
                }

            })

        })


    });
}



//getUsersAssociatedConsultantId(21).then(res=>console.log(res))


function updateUser(obj){
    return new Promise(function (resolve, reject) {

        User.findOneAndUpdate({_id:obj.id},{
            $set:{
                user_name: obj.user_name,
                user_state_code: obj.user_state_code,
                user_state: obj.user_state,
                user_city: obj.user_city,
                user_city_code: obj.user_city_code,
                user_self_introduce: obj.user_self_introduce,

            }

        },{ new: true },function(err,course) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log('user update successfully');
            resolve(course);
        });
    });
}


function addAvataToUser(userEmail,path){
    return new Promise(function (resolve, reject) {

        User.findOneAndUpdate({user_email:userEmail},{
            $set:{
                user_avatar_path: path,
            }

        },{ new: true },function(err,course) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log('user update successfully');
            resolve(course);
        });
    });
}



function login(obj){
    return new Promise(function (resolve, reject) {
        User.findOne({
            user_email: obj.user_email
        }, function(err, user) {
            if (err) reject(err);
            if (!user) {
                console.log("can not foud user")
                resolve({ success: false, message: 'Authentication failed. User not found.' });

            } else if (user) {
                if (!bcrypt.compareSync(obj.user_password, user.user_password)) {
                    console.log("passwords are not matched")
                    resolve({ success: false, message: 'Authentication failed. Wrong password.' });
                } else {
                    console.log("login successful")
                    user.user_password = "";
                    resolve({  success: true, message: 'login successfull',user:user} );
                }
            }
        })

    });
}

function changePassword(userId,oldPassword,newPassword){
    return new Promise(function (resolve, reject) {
        User.findOne({
            _id: userId
        }, function(err, user) {
            if (err) reject(err);
            if (!user) {
                console.log("can not foud user")
                resolve({ success: false, message: 'change password failed. User not found.' });

            } else if (user) {
                if (!bcrypt.compareSync(oldPassword, user.user_password)) {
                    console.log("passwords are not matched")
                    resolve({ success: false, message: 'change password failed. Wrong password.' });
                } else {
                    console.log("change password")
                    user.user_password =  bcrypt.hashSync(newPassword, saltRounds)
                    user.save(function(err,user) {
                        if (err) reject(err);
                        console.log('change paasword successfully');
                        resolve({  success: true, message: 'change paasword successfully'} );
                    });




                }
            }
        })

    });
}




function createParentConsultant(obj){
    return new Promise(function (resolve, reject) {
        ParentConsultant.findOne({
            parent_id: obj.parent_id
        }, function(err, parentConsultant) {
            if (err) reject(err);
            if (parentConsultant) {
                resolve(parentConsultant);
            } else {
                var dbParentConsultant = new ParentConsultant(obj);
                dbParentConsultant.save(function(err,newParentConsultant) {
                    if (err) reject(err);
                    console.log(newParentConsultant);
                    resolve(newParentConsultant);
                })
            }
        })






 });
}



function getParentConsultantByParentId(parent_id){
    return new Promise(function (resolve, reject) {
        ParentConsultant.findOne({
            parent_id: parent_id
        }, function(err, parentConsultant) {
            if (err) reject(err);
            resolve(parentConsultant)
        })

    });
}

function getParentConsultantByConsultantId(consultant_id){
    return new Promise(function (resolve, reject) {
        ParentConsultant.find({
            consultant_id: consultant_id
        }, function(err, parentConsultants) {
            if (err) reject(err);
            resolve(parentConsultants)
        })

    });
}




function updateParentConsultantStatus(parentId,status){
    return new Promise(function (resolve, reject) {

        ParentConsultant.findOneAndUpdate({parent_id:parentId},{
            $set:{
                status: status,
                num_tasks_handle:0,
            }

        },{ new: true },function(err,parentConsultant) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log('parentConsultant status update successfully');
            resolve(parentConsultant);
        });
    });
}





function updateParentConsultant(obj){
    return new Promise(function (resolve, reject) {

        ParentConsultant.findOneAndUpdate({parent_id:obj.parent_id},{
            $set:{
                num_tasks_replay: obj.num_tasks_replay,
                num_tasks_handle: obj.num_tasks_handle,
            }

        },{ new: true },function(err,course) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log('ParentConsultant update successfully');
            resolve(course);
        });
    });
}


// test

 var testObj={


        parent_id:2,
            num_tasks_replay:2 , // need replay tasks number
        parent_name:"wma",
        parent_email:"tasf",
        status:2,  // 0  delete 1 activity 2 pending
        consultant_id:2,
        num_tasks_handle:1 // need handle tasks number




 }
  //  createParentConsultant(testObj).then(res=>console.log(res))


var testObj2={
    parent_id:1,
    num_tasks_replay:6 , // need replay tasks number
    num_tasks_handle:16 // need handle tasks number


}


//updateParentConsultant(testObj2).then(res=>console.log(res))

//getParentConsultantByConsultantId(2).then(res=>console.log(res))
//getParentConsultantByParentId(1).then(res=>console.log(res))

// test

// var obj = {
//         user_name: "wma4",
//         user_email: "wma@gmail.com",
//         user_password:"pass", // bcrypt.hashSync("pass", saltRounds)"",
//         user_status: "Active",
//         user_type: "parent",
//         parent_ids:[]
// }

// createUser(obj).then(function process(res){
//     console.log(res);
// }).catch(function onRejected(error){
//         console.error(error);
//     })

// login(obj).then(function onFulfilled(value){
//     console.log(value);
// }).catch(function onRejected(error){
//     console.error(error);
// });


var updateUserObj = {
    user_name: "test2",
    id:7,
    user_status: 2, // 0    1 activity  2 pending  (maybe need pay or need approve by admin)

    user_state_id:1,
    user_state:"北京",
    user_city:"北京市",
    user_self_introduce:"张三"
}

//updateUser(updateUserObj).then(resove=> console.log(resove))

//getConsultants().then(resovle=>console.log(resovle))



function createCourse(obj){
    return new Promise(function (resolve, reject) {
        var dbCourse = new Course(obj);
        dbCourse.course_level_name            = transfer.do(dbCourse.course_level_name)
        dbCourse.course_name                  = transfer.do(dbCourse.course_name)
        dbCourse.course_goal                  = transfer.do(dbCourse.course_goal)
        dbCourse.course_syllabus              = transfer.do(dbCourse.course_syllabus)
        dbCourse.course_type                   = transfer.do(dbCourse.course_type)

        console.log(dbCourse)
        dbCourse.save(function(err,course) {
        if (err){
            console.log(err)
            reject(err);
        }
        console.log('course saved successfully');
        resolve(course);
        });
    });
}



function updateCourse(obj){
    return new Promise(function (resolve, reject) {
        var dbCourse = new Course(obj);
        dbCourse.course_level_name            = transfer.do(dbCourse.course_level_name)
        dbCourse.course_name                  = transfer.do(dbCourse.course_name)
        dbCourse.course_goal                  = transfer.do(dbCourse.course_goal)
        dbCourse.course_syllabus              = transfer.do(dbCourse.course_syllabus)
        dbCourse.course_type                   = transfer.do(dbCourse.course_type)
        dbCourse._id = obj.id
        Course.findOneAndUpdate({_id:obj._id},{
            $set:{
                course_level: dbCourse.course_level,
                course_level_name: dbCourse.course_level_name,
                course_name: dbCourse.course_name,
                course_goal: dbCourse.course_goal,
                course_syllabus: dbCourse.course_syllabus,
                course_type: dbCourse.course_type,
            }

        },{ new: true },function(err,course) {
        if (err){
            console.log(err)
            reject(err);
        }
        console.log('course update successfully');
        resolve(course);
        });
    });
}


function getAllCourse(){
    return new Promise(function (resolve, reject) {

        var query = Course.find({}).sort({course_type:-1,course_level:1})

        query.exec(
            function (err, courses) {
                if (err){
                    console.log(err)
                    reject(err);
                }

                resolve(courses);
            }

        )

    });
}
function deleteCourse(deleteId){
    return new Promise(function (resolve, reject) {
        Course.findOneAndRemove({_id:deleteId}, function (err, courses) {
            if (err){
                console.log(err)
                reject(err);
            }
            resolve({ success: true, message: 'delete course successful' });

        })

    });

}
var courseobj = {
	course_level: 1,
	course_level_name: "家长一期",
	course_name: "教育期",
	course_goal: "协助家长建立对ASD核心问题的了解、知道ASD优势所代表的意义、一般孩子语言发展的历程、以及动机的培养。以及介绍一些简单的策略，父母要能够「内观」自己的行为，面对孩子时可以以平常心，用合宜的方式建立引导的第一步",
    course_syllabus: "本期将会引导家长以不同的眼光看ASD，你会发现孩子有许多的能力是你未曾想过的，同时经历过本期你可以明确的建立引导方向，对你的孩子充满信心，对你自己也充满信心，知道要如何规划孩子的目标。初步的引导式参与关系要父母能够先稳住自己「教」的心态，我们希望父母将本期所学的一些概念能够简单的应用出来开始潜移默化.",
    course_type:"家长"
};

// createCourse(courseobj).then(function process(res){
//     console.log(res);
// }).catch(function onRejected(error){
//         console.error(error);
//     });
// getAllCourse().then(function process(res){
//     console.log(res)
// })
// updateCourse(courseobj).then(function process(res){
//     console.log(res);
// }).catch(function onRejected(error){
//         console.error(error);
//     });


// deleteCourse(15).then(function process(res){
//     console.log(res);
// }).catch(function onRejected(error){
//         console.error(error);
//     });


function createGogal(obj){
    return new Promise(function (resolve, reject) {

        var dbGogal = new Gogal(obj);
        dbGogal.course_level_name            = transfer.do(dbGogal.course_level_name)
        dbGogal.course_name                  = transfer.do(dbGogal.course_name)
        dbGogal.course_goal                  = transfer.do(dbGogal.course_goal)
        dbGogal.course_syllabus              = transfer.do(dbGogal.course_syllabus)
        dbGogal.course_type                   = transfer.do(dbGogal.course_type)
        dbGogal.goal_name                    = transfer.do(dbGogal.goal_name)
        dbGogal.goal_describ                 = transfer.do(dbGogal.goal_describ)
        dbGogal.goal_requirement             = transfer.do(dbGogal.goal_requirement)

        dbGogal.save(function(err,gogal) {
        if (err) {
            console.log(err)
            reject(err);
        }
        console.log('gogal saved successfully');
        resolve(gogal);
        });
    });
}



function updateGogal(obj){
    return new Promise(function (resolve, reject) {
        var dbGogal = new Gogal(obj);
        dbGogal.course_level_name            = transfer.do(dbGogal.course_level_name)
        dbGogal.course_name                  = transfer.do(dbGogal.course_name)
        dbGogal.course_goal                  = transfer.do(dbGogal.course_goal)
        dbGogal.course_syllabus              = transfer.do(dbGogal.course_syllabus)
        dbGogal.course_type                   = transfer.do(dbGogal.course_type)
        dbGogal.goal_name                    = transfer.do(dbGogal.goal_name)
        dbGogal.goal_describ                 = transfer.do(dbGogal.goal_describ)
        dbGogal.goal_requirement             = transfer.do(dbGogal.goal_requirement)
        dbGogal._id = obj.id
        Gogal.findOneAndUpdate({_id:obj._id},{
            $set:{
                course_level_name: dbGogal.course_level_name,
                course_name: dbGogal.course_name,
                course_goal: dbGogal.course_goal,
                course_syllabus: dbGogal.course_syllabus,
                course_type: dbGogal.course_type,
                goal_name:dbGogal.goal_name,
                goal_describ:dbGogal.goal_describ,
                goal_requirement:dbGogal.goal_requirement,
            }

        },{ new: true },function(err,gogal) {
        if (err){
            console.log(err)
            reject(err);
        }
        console.log('gogal update successfully');
        resolve(gogal);
        });
    });
}


function addVideoForGogal(gogalId,video){
    console.log("start add")
    return new Promise(function (resolve, reject) {
        var dbvideo = new Video(video)

        Gogal.findById(gogalId, function(err, gogal) {
            gogal.demo_video.push(dbvideo);
            gogal.save(function(err,savedgogle){
            if (err) {
                console.log(err)
                reject(err);
            }
            console.log('gogal add video successfully');
            resolve(savedgogle);

            });
        })
    });
}

function deleteVideoForGogal(gogalId,video_id){
    return new Promise(function (resolve, reject) {

        Gogal.findOneAndUpdate(
            { _id: gogalId },
            { $pull: { demo_video: { _id: video_id }}}).exec()
            .then(function (savedgogl) {
                console.log('--------gogal delete video successfully');
                console.log(savedgogl)

                for(var i = 0;i < savedgogl.demo_video.length;i++){
                    if (savedgogl.demo_video[i]._id = video_id ){
                        if(savedgogl.demo_video[i].video_path){


                             fs.unlink('./uploads/'+savedgogl.demo_video[i].video_path, (err) => {
                               if (err){
                                   console.error(err)
                               }else{
                                   console.log('file was deleted');
                               }

                             })
                         }
                    }
                }

                resolve({ success: true, message: 'delete delete video successful' });

                // delete file

            }).catch(error=>{reject(error)})


    // Gogal.findById(gogalId, function(err, gogal) {
    //
    //     var newArray = [];
    //     for(var i=0;i<gogal.demo_video.length;i++){
    //         if(gogal.demo_video[i]._id != video_id){
    //             newArray.push(gogal.demo_video[i]);
    //         }
    //     }
    //     gogal.demo_video =  newArray;
    //     gogal.save(function(err,savedgogl){
    //     if (err) {
    //         console.log(err)
    //         reject(err);
    //     }
    //     console.log('gogal remove video successfully');
    //     resolve(savedgogl);
    //
    //     });
    // })

    })
}




function deleteGogal(deleteId){
    return new Promise(function (resolve, reject) {
        Gogal.findOneAndRemove({_id:deleteId}, function (err, gogal) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log("delete gogal successful")
            resolve({ success: true, message: 'delete delete gogal successful' });
        })

    });

}



function getAllGogal(){
    return new Promise(function (resolve, reject) {
        Gogal.find({}, function (err, gogals) {
            resolve(gogals);
        })

    });
}


function getAllGogalByCouarseId(courseId){
    return new Promise(function (resolve, reject) {
        Gogal.find({course_id:courseId}, function (err, gogals) {
            resolve(gogals)
        })


    });
}



var districtSchema = new Schema({
    name:String,
    code:Number
})
var District = db.model('District', districtSchema);





var citySchema = new Schema({
    name:String,
    district:[districtSchema]


})
//
var City = db.model('City', citySchema);



var stateChema = new Schema({
    name:String,
    city:[citySchema]

})

var State = db.model('State', stateChema,'cities');

function getAllCityInfo(){
    return new Promise(function (resolve, reject) {
        State.find({}, function (err, states) {
            resolve(states);
        })

    });
}

// getAllCityInfo().then(function process(res){
//     console.log(res[5].name)
//     console.log(res[5].city[0].name)
//
// })


// test

// var gogalObj = {
// 	course_level: 1,
// 	course_level_name: "家長",
//     course_name: "教育期",
//     course_goal: "協助家長建立對ASD核心問題的了解、知道ASD優勢所代表的意義、一般孩子語言發展的歷程、以及動機的培養。以及介紹一些簡單的策略，父母要能夠「內觀」自己的行為，面對孩子時可以以平常心，用合宜的方式建立引導的第一步",
//     course_syllabus: "本期將會引導家長以不同的眼光看ASD，你會發現孩子有許多的能力是你未曾想過的，同時經歷過本期你可以明確的建立引導方向，對你的孩子充滿信心，對你自己也充滿信心，知道要如何規劃孩子的目標。初步的引導式參與關係要父母能夠先穩住自己「教」的心態，我們希望父母將本期所學的一些概念能夠簡單的應用出來開始潛移默化.",
//     goal_seq:1,
//     course_type:"家長",
//     goal_name: "「主動式學習方案」專論",
//     goal_describ: "主動式學習方案是針對ASD所開發出來的家長訓練計畫，旨在提供孩子能夠接受全時的引導而不是忙於各個療育課程。整個方案分成5期，先提供家長對ASD正確的觀點，然後讓家長對阻礙引導式參與關係建立的行為有所認識，再來就是試著發展引導式參與關係，也就是真正的讓孩子發展ASD未成長的神經迴路。最後我們要家長能夠將這種人類自然傳承經驗的方式變成生活習慣，讓你無時無刻都在協助孩子克服她最大的困難",
//     goal_requirement: "1.你知道主動式參與方案的核心精神 2.你知道主動式參與方案是針對孩子主要照顧者的課程 3.你知道孩子生命中最重要的是父母，即使是在孩子表現非常混亂的時候亦然 4.你了解主動式學習方案最重要的工具就是引導式參與關係的建立 5.你知道孩子要克服ASD的核心問題，必須要將你自己變成專家才能提供全時的引導",
//     demo_video:[{
//         videoName:"范例视频1",
//         video_path:"/videos/1/1/myvideo.mp4"
//     },
//     {
//         videoName:"范例视频2",
//         video_path:"/videos/1/1/myvideo2.mp4"
//     },

// ]
// };


// createGogal(gogalObj).then(function process(res){
//     console.log(res);
// }).catch(function onRejected(error){
//         console.error(error);
//     });



// getAllGogal().then(function process(res){
//     console.log(res)
// })

var video = {
    video_name:"test",
    video_path:"path"

}

// addVideoForGogal(13,video).then(function process(res){
//     console.log(res)
// })
// deleteVideoForGogal(12,  14)



// test


function createUserTask(obj){

    return new Promise(function (resolve, reject){
        var dbUserTask = new UserTask(obj);
        dbUserTask.task_status = 1
        dbUserTask.save(function(err,usertask) {
        if (err) reject(err);
        console.log('user task saved successfully')
        // update parent consultant dat
            console.log("parentId:"+usertask.user_id)
            ParentConsultant.findOne({
                parent_id: usertask.user_id
            }, function(err, parentConsultant) {
                if (err) reject(err);
                if(parentConsultant){
                    console.log(parentConsultant)
                    ParentConsultant.findOneAndUpdate({parent_id:parentConsultant.parent_id},{
                        $set:{
                            num_tasks_replay: parentConsultant.num_tasks_replay+1,
                        }

                    },{ new: true },function(err,course) {
                        if (err){
                            console.log(err)
                            reject(err);
                        }
                        console.log('ParentConsultant update successfully');
                        resolve(course);
                    });


                }



            })


        resolve(usertask);
        });
    });
}

function getUserTaskByUserId(id){
    return new Promise(function (resolve, reject) {
        UserTask.find({user_id:id}, function (err, userTasks) {
            resolve(userTasks)
        })





    });
}

function getUserTaskById(id){
    return new Promise(function (resolve, reject) {
        UserTask.findOne({
            _id: id
        }, function(err, userTask) {
            if (err) reject(err);
            if (!userTask) {
                console.log("can not foud task")
                resolve({});
            } else if (userTask) {
                resolve(userTask );
            }

        })

    });
}


function updateUserTaskStatus(id,status){
    return new Promise(function (resolve, reject) {
        UserTask.findOneAndUpdate({_id:id},{
            $set:{
                task_status:status
            }

        },{ new: true },function(err,userTask) {
            if (err){
                console.log(err)
                reject(err);
            }
            if (userTask){



                ParentConsultant.findOne({
                    parent_id: userTask.user_id
                }, function(err, parentConsultant) {
                    if (err) reject(err);
                    if(parentConsultant){
                        console.log(parentConsultant)
                        ParentConsultant.findOneAndUpdate({parent_id:parentConsultant.parent_id},{
                            $set:{
                                num_tasks_handle: parentConsultant.num_tasks_handle-1,
                            }

                        },{ new: true },function(err,course) {
                            if (err){
                                console.log(err)
                                reject(err);
                            }
                            console.log('ParentConsultant update successfully');
                            resolve(course);
                        });


                    }



                })





                console.log('task update successfully');
                resolve(userTask);
            }else{

                console.log('task update fail');
                resolve({});
            }

        });

    });
}



function addReplayForUserTask(userTaskId,replay){
    return new Promise(function (resolve, reject) {
        var newReplay = new Replay(replay)
        UserTask.findOne({_id:userTaskId}, function(err, userTask) {

            if(userTask){
                userTask.replays.push(newReplay);
                userTask.save(function(err,savedUserTask){
                    if (err) {
                        console.log(err)
                        reject(err);
                    }
                    console.log('add replay to user task successfully');


                    // update parent and consult infomation

                    ParentConsultant.findOne({
                        parent_id: savedUserTask.user_id
                    }, function(err, parentConsultant) {
                        if (err) reject(err);
                        if(parentConsultant){
                            console.log(parentConsultant)

                            if (newReplay.replay_type ==1){
                                ParentConsultant.findOneAndUpdate({parent_id:parentConsultant.parent_id},{
                                    $set:{
                                        num_tasks_handle: parentConsultant.num_tasks_handle+1,
                                        num_tasks_replay: parentConsultant.num_tasks_replay-1,
                                    }

                                },{ new: true },function(err,course) {
                                    if (err){
                                        console.log(err)

                                    }
                                    console.log('ParentConsultant update successfully');

                                });

                            }else{
                                ParentConsultant.findOneAndUpdate({parent_id:parentConsultant.parent_id},{
                                    $set:{
                                        num_tasks_replay: parentConsultant.num_tasks_replay+1,
                                        num_tasks_handle: parentConsultant.num_tasks_handle-1,
                                    }

                                },{ new: true },function(err,course) {
                                    if (err){
                                        console.log(err)

                                    }
                                    console.log('ParentConsultant update successfully');

                                });


                            }



                        }



                    })

                    resolve(savedUserTask);

                });

            }else{

                resolve({});
            }

        })

    });
}


// test

var userTaskObj ={
    user_id: 1,
    course_id: 1,
    goal_break_id: 1,
    goal_break_id:2,
    task_title:"主动式学习方案是针对ASD所开发出来",
    task_content:"你知道孩子要克服",
    task_status:1

    }

// createUserTask(userTaskObj).then(function process(res){
//     console.log(res);
// }).catch(function onRejected(error){
//         console.error(error);
//     });



//  getUserTaskByUserId(
//    1
//  ).then(function process(res){
//     console.log(res)
// })

// var replayObj = {
//     user_id:3,
//     replay_title:"xxxxxx",
//     replay_content:"yyyyyyy",
//     replay_vides:[{
//         videoName:"videoreplay",
//         video_path:"/videos/1/1/myvideo.mp4"
//     }
//     ]
//
// }
// addReplayForUserTask(1,replayObj).then(function process(res){
//     console.log(res)
// })











function createGogalBreak(obj){
    console.log("star createGogalBreak")
    return new Promise(function (resolve, reject){

        var dbGogalBreak = new  GogalBreak(obj);
        // dbGogalBreak.course_level_name           = transfer.do(dbGogalBreak.course_level_name)
        // dbGogalBreak.course_name   = transfer.do(dbGogalBreak.course_name)
        // dbGogalBreak.goal_name           = transfer.do(dbGogalBreak.goal_name)
        // try {
        //     console.log("dbGogalBreak.breaks.length:" + dbGogalBreak.breaks.length)
        //     for (var i = 0; i < dbGogalBreak.breaks.length; i++) {
        //         console.log("dbGogalBreak.breaks[i].tasks.length:" + dbGogalBreak.breaks[i].tasks.length)
        //         for (var j = 0; j < dbGogalBreak.breaks[i].tasks.length; j++) {
        //             console.log("star createGogalBreak")
        //             dbGogalBreak.breaks[i].tasks[j].task_title = transfer.do(dbGogalBreak.breaks[i].tasks[j].task_title);
        //             dbGogalBreak.breaks[i].tasks[j].task_content = transfer.do(dbGogalBreak.breaks[i].tasks[j].task_content);
        //         }
        //         dbGogalBreak.breaks[i].break_title = transfer.do(dbGogalBreak.breaks[i].break_title);
        //         dbGogalBreak.breaks[i].break_desc = transfer.do(dbGogalBreak.breaks[i].break_desc);
        //         dbGogalBreak.breaks[i].break_question = transfer.do(dbGogalBreak.breaks[i].break_question);
        //         dbGogalBreak.breaks[i].break_requirement = transfer.do(dbGogalBreak.breaks[i].break_requirement);
        //
        //     }
        // }catch(err)
        //     {
        //         console.log(err)
        //     }
        dbGogalBreak.break_status = 1
        dbGogalBreak.save(function(err,gogalBreak) {
        if (err){
            console.log(err)
            reject(err);
        }
        console.log('gogal break saved successfully')
        resolve(gogalBreak);
        });
    });
}


function getGogalBreakByUserId(id){
    return new Promise(function (resolve, reject) {
        GogalBreak.find({user_id:id}, function (err, gogalBreak) {
            if (gogalBreak.length ==0){
                resolve({})
            }
            resolve(gogalBreak)
        })

    });
}

function getAllGogalBreak(){
    return new Promise(function (resolve, reject) {
        GogalBreak.find({}, function (err, gogalBreaks) {
            if (gogalBreaks.length == 0) {
                resolve({})
            }
            resolve(gogalBreaks)
        })
    });
    }




        function deleteGogalBreak(deleteId) {
    return new Promise(function (resolve, reject) {
        GogalBreak.findOneAndUpdate({_id:deleteId},{
            $set:{
                break_status:0
            }

        },{ new: true },function(err,gogalbreak) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log('gogal break delete successfully');
            resolve(gogalbreak);
        });

    });
}


    function updateGogalBreak(obj){
    return new Promise(function (resolve, reject) {
        GogalBreak.findOneAndUpdate({_id:obj.id},{
            $set:{
                break_title:obj.break_title,
                break_desc:obj.break_desc,
                break_question:obj.break_question,
                break_requirement:obj.break_requirement,
            }

        },{ new: true },function(err,gogalbreak) {
            if (err){
                console.log(err)
                reject(err);
            }
            console.log('gogal break update successfully');
            resolve(gogalbreak);
        });

    });
}







// function addBreakForGogal(gogalbreakId,breakobj){
//     console.log("start add for gogal id: "+gogalbreakId)
//     return new Promise(function (resolve, reject) {
//         var dbBreakobj= new Break(breakobj)
//
//         GogalBreak.findById(gogalbreakId, function(err, gogalbreak) {
//             if(gogalbreak){
//                 gogalbreak.breaks.push(dbBreakobj);
//                 gogalbreak.save(function(err,savedGogabreak){
//                     if (err) {
//                         console.log(err)
//                         reject(err);
//                     }
//                     console.log('gogal break add break successfully');
//                     resolve(savedGogabreak);
//
//                 });
//
//             }else{
//                 reject("can not found gogalbreak");
//             }
//
//         })
//     });
// }

// function updateaBreakForGogal (gogalbreakId,breakobj){
//     console.log("start update")
//     return new Promise(function (resolve, reject) {
//         var dbBreakobj= new Break(breakobj)
//
//         GogalBreak.findById(gogalbreakId, function(err, gogalbreak) {
//             if (gogalbreak){
//                 var findindex = -1;
//                 for(var i = 0; i < gogalbreak.breaks.length;i++){
//                     console.log(gogalbreak.breaks[i])
//                     if(gogalbreak.breaks[i]._id == breakobj._id){
//                         findindex = i;
//                         break;
//                     }
//                 }
//                 if (findindex == -1){
//                     resolve("can not fund break by break id:"+breakobj)
//                     return;
//                 }
//                 console.log("fund break by break id:" + findindex)
//
//                 gogalbreak.breaks.set(findindex,dbBreakobj)
//                 gogalbreak.save(function(err,savedGogabreak){
//                     if (err) {
//                         console.log(err)
//                         reject(err);
//                     }
//                     console.log('gogal break update break successfully');
//                     resolve(savedGogabreak);
//                 });
//             }else{
//                 reject("can not find gogalbreak by gogalbreakId");
//
//             }
//
//
//         })
//     });
// }
//
// function deleteBreakForGogal(gogalbreakId,break_id){
//     return new Promise(function (resolve, reject) {
//
//         GogalBreak.findOneAndUpdate(
//             { _id: gogalbreakId },
//             { $pull: { breaks: { _id: break_id }}}).exec()
//             .then(function (deleteGogalBreak) {
//                 console.log("delete gogal break successful")
//                 resolve(deleteGogalBreak)
//
//             })
//         // GogalBreak.findById(gogalbreakId, function(err, gogalbreak) {
//
//         //     var removeId = -1
//         //     for(var i=0;i<gogalbreak.breaks.length;i++){
//         //         if(gogalbreak.breaks[i]._id == break_id){
//         //             removeId = i
//
//         //         }
//         //     }
//
//         //     if (removeId >0){
//         //         gogalbreak.save(function(err,gogalbreak){
//         //             if (err) {
//         //                 console.log(err)
//         //                 reject(err);
//         //             }
//         //             console.log('gogalbreak remove break successfully');
//         //             resolve(gogalbreak);
//
//         //         });
//
//
//         //     }else{
//         //         reject("can not found braek by id:"+break_id);
//         //     }
//
//
//
//
//         // })
//
//     })
// }







function addTaskForGogalBreak(gogalbreakId,breakId,taskobj){
    console.log("start add")
    return new Promise(function (resolve, reject) {
        var dbtaskobj= new Task(taskobj)

        GogalBreak.findById(gogalbreakId, function(err, gogalbreak) {
            if (err) {
                console.log(err)
                reject(err);
                return
            }
            if(gogalbreak && gogalbreak._id >-1){
                var selected = -1
                for(var i=0;i<gogalbreak.breaks.length;i++){
                    if(gogalbreak.breaks[i]._id == breakId){
                        selected = i
                    }
                }
                if(selected >-1){
                    gogalbreak.breaks[selected].tasks.push(dbtaskobj)
                    gogalbreak.save(function(err,savedGogabreak){
                        if (err) {
                            console.log(err)
                            reject(err);
                        }
                        console.log('gogal break add task successfully');
                        resolve(savedGogabreak);

                    });

                }else{
                    reject("can not fund break id:"+breakId);

                }
            }else{
                reject("can not fund gogalbrak id:"+gogalbreakId);
            }


        })
    });
}

 function updateTaskForGogalBreak(gogalbreakId,breakId,taskobj){
        console.log("start update")
        return new Promise(function (resolve, reject) {
            var dbtaskobj= new Task(taskobj)

            GogalBreak.findById(gogalbreakId, function(err, gogalbreak) {
                if (err) {
                    console.log(err)
                    reject(err);
                    return
                }
                if(gogalbreak && gogalbreak._id >-1){
                var selectedBreakIndex = -1
                var selectedBreakTaskIndex = -1


                for (var i = 0; i < gogalbreak.breaks.length; i++) {
                    if (gogalbreak.breaks[i]._id == breakId){
                        selectedBreakIndex = i;
                        for (var j = 0; j < gogalbreak.breaks[i].tasks.length; j++) {
                            if(gogalbreak.breaks[i].tasks[j]._id == dbtaskobj._id){
                                selectedBreakTaskIndex = j;
                            }
                        }
                    }

                }
                console.log("selectedBreakIndex:"+selectedBreakIndex)
                console.log("selectedBreakTaskIndex:"+selectedBreakTaskIndex)
                if(selectedBreakIndex >-1 && selectedBreakTaskIndex >-1){
                    gogalbreak.breaks[selectedBreakIndex].tasks.set(selectedBreakTaskIndex,dbtaskobj)
                    gogalbreak.save(function(err,savedGogabreak){
                        if (err) {
                            console.log(err)
                            reject(err);
                        }
                        console.log('gogal break update task successfully');
                        resolve(savedGogabreak);

                    });

                }else{
                    reject("can not fund break id and task id :"+breakId+" "+taskobj._id);

                }
                }else{
                    reject("can not fund gogalbrak id:"+gogalbreakId);
                }

            })
        });
    }



function deleteTaskForGogalBreak(gogalbreakId,break_id,taskId){
    return new Promise(function (resolve, reject) {

        var selectedBreakIndex = -1
        GogalBreak.findById(gogalbreakId, function(err, gogalbreak) {
            if (err) {
                console.log(err)
                reject(err);
                return
            }
            if(gogalbreak && gogalbreak._id >-1){
                console.log(gogalbreak)
                for (var i = 0; i < gogalbreak.breaks.length; i++) {
                    if (gogalbreak.breaks[i]._id == break_id){
                        selectedBreakIndex = i;

                    }

                }

                console.log("selectedBreakIndex:"+selectedBreakIndex)

                var removeTaskIndex = -1;
                for (var j = 0; j <   gogalbreak.breaks[selectedBreakIndex].tasks.length; j++) {
                    if(gogalbreak.breaks[selectedBreakIndex].tasks[j]._id == taskId){
                        removeTaskIndex = j;
                    }
                }

                console.log("removeTaskIndex:"+removeTaskIndex)
                gogalbreak.breaks[selectedBreakIndex].tasks.splice(removeTaskIndex,1)

                console.log(gogalbreak.breaks[selectedBreakIndex].tasks.length)
                console.log('connection : %j', gogalbreak.breaks[selectedBreakIndex].tasks);
                gogalbreak.save(function(err,savedGogabreak){
                    if (err) {
                        console.log(err)
                        reject(err);
                    }
                    console.log('gogal break task delete successfully');
                    resolve(savedGogabreak);

                });






            }else{
                reject("can not fund gogalbrak id:"+gogalbreakId);
            }

        })





        // GogalBreak.findOneAndUpdate(
        //     { _id: gogalbreakId},
        //     {
        //         $pull: {
        //             tasks:{ _id: taskId }
        //         }
        //     }
        //
        //     ).exec()
        //     .then(function (deleteGogalBreak) {
        //         console.log(deleteGogalBreak)
        //     })

    })
}





//test

var gogalBreakObj = {
    user_id:0,
    course_id:11,
    goal_id:101,
    break_title:"breakTitle2",
    break_desc:"break_desc2",
    break_question:"break_question2",
    break_requirement:"break_requirement2"
    // breaks:[
    //     {
    //
    //         break_title:"breakTitle1",
    //         break_desc:"break_desc1",
    //         break_question:"break_question1",
    //         break_requirement:"break_requirement1",
    //         tasks:[
    //             {
    //                 task_title:"task_title1",
    //                 task_content:"task_content1"
    //
    //         },
    //             {
    //                 task_title:"task_title2",
    //                 task_content:"task_content2"
    //
    //             },
    //
    //         ]
    //
    //
    // },
    //
    // {
    //
    //     break_title:"breakTitle2",
    //     break_desc:"break_desc2",
    //     break_question:"break_question2",
    //     break_requirement:"break_requirement2",
    //     tasks:[
    //         {
    //             task_title:"task_title3",
    //             task_content:"task_content3"
    //
    //         },
    //         {
    //             task_title:"task_title4",
    //             task_content:"task_content4"
    //
    //         },
    //
    //     ]

    //
    // },
    //
    // ]

}

// createGogalBreak(gogalBreakObj).then(function process(res){
//     console.log("test")
//     console.log(res)
// })


var break3 = {

    break_title:"breakTitle3",
    break_desc:"break_desc3",
    break_question:"break_question3",
    break_requirement:"break_requirement3",
    tasks:[
    {
        task_title:"task_title3",
        task_content:"task_content3"

    },
    {
        task_title:"task_title4",
        task_content:"task_content4"

    },

]


}
// addBreakForGogal(9,break3).then(resove =>{
//     console.log(resove)
// }).catch(function(error) {
//     console.log(error);
// });


var break3_update = {
    _id:22,
    break_title:"breakTitle3_1",
    break_desc:"break_desc3_1",
    break_question:"break_question3_1",
    break_requirement:"break_requirement3_1",
    tasks:[
        {
            task_title:"task_title3_1",
            task_content:"task_content3"

        },
        {
            task_title:"task_title4_1",
            task_content:"task_content4"

        },

    ]


}



// updateaBreakForGogal(9,break3_update).then(resove =>{
//     console.log(resove)
// }).catch(function(error) {
//     console.log(error);
// });

// deleteGogalBreak(12).then(resove=> console.log(resove))

// getGogalBreakByUserId(0).then(function process(res){
//     console.log(res)

var task =    {
    _id:56,
    task_title:"task_title5_5",
    task_content:"task_content56"

}
// addTaskForGogalBreak(2,1,task)

// updateTaskForGogalBreak(9,22,task).then(res => console.log(res)).catch(err=>console.log(err))
// deleteTaskForGogalBreak(9,20,49)
module.exports = {

    createUser,
    login,
    getUserByname,
    getUserById,
    getUsersAssociatedConsultantId,
    getUsersAssociatedParentId,
    createCourse,
    getAllCourse,
    updateCourse,
    deleteCourse,

    createGogal,
    getAllGogal,
    getAllGogalByCouarseId,
    updateGogal,
    deleteGogal,
    addVideoForGogal,
    deleteVideoForGogal,

    createUserTask,
    getUserTaskByUserId,
    getUserTaskById,
    addReplayForUserTask,

    createGogalBreak,
    getGogalBreakByUserId,
    deleteGogalBreak,
    getAllGogalBreak,
    // addBreakForGogal,
    // updateaBreakForGogal,
    // deleteBreakForGogal,
    addTaskForGogalBreak,
    updateTaskForGogalBreak,
    deleteTaskForGogalBreak,
    getAllCityInfo,

    createParentConsultant,
    updateParentConsultant,
    updateParentConsultantStatus,
    getParentConsultantByParentId,
    getParentConsultantByConsultantId,
    updateUser,
    getConsultants,
    updateUserTaskStatus,
    addReplayForUserTask,
    updateGogalBreak,
    addAvataToUser,
    changePassword,
    createUserFeedback



}

