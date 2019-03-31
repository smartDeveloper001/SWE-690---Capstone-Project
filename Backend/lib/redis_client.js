var redis = require('redis');

var client = redis.createClient(6379, "localhost");

client.auth('xiuxiu00',function(err,reply) {
   if(err){
       console.error(err)
   }
});



client.on('ready',function() {
    console.log("************Redis is ready to store token informaiton**********");
});

client.on('error',function() {
    console.log("Error in Redis");
});



var setValue = function(key,value) {
    var promise = new Promise(function(resolve, reject){
        client.set(key,value,function(err,reply) {
            if (err) {
                reject(err);
            }else{
                resolve(reply)
            }
        });

    });

    return promise;
};





var getValue = function(key) {
    var promise = new Promise(function(resolve, reject){
        client.get(key,function(err,reply) {
            if (err) {
                reject(err);
            }else{
                resolve(reply)
            }
        });
    });

    return promise;
};


var deletKey = function(key) {
    var promise = new Promise(function(resolve, reject){
        client.del(key,function(err,reply) {
            if (err) {
                reject(err);
            }else{
                resolve("OK")
            }
        });
    });

    return promise;
};


var existKey = function(key) {
    var promise = new Promise(function(resolve, reject){
        client.exists(key,function(err,reply) {
            if (err) {
                reject(err);
            }else{
                resolve(reply)
            }
        });

    });

    return promise;
};





module.exports = {
    setValue,
    getValue,
    deletKey,
    existKey
}



