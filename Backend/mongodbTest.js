var config      = require('./config'); 

var mongoose    = require('mongoose');

mongoose.connect(config.database);

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    console.log("connect successfull")

});

// var schema = new mongoose.Schema({ name: 'string', size: 'string' });
// var Tank = mongoose.model('Tank', schema);

// var small = new Tank({ size: 'small' });
// // small.save(function (err) {
// //   if (err) return handleError(err);
// //   console.log("save successful")
// // });

// var personSchema = new mongoose.Schema({
//     _id: mongoose.Schema.Types.ObjectId,
//     name: String,
//     age: Number,
//     stories: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Story' }]
//   });
  
//   var storySchema = new mongoose.Schema({
//     author: { type: mongoose.Schema.Types.ObjectId, ref: 'Person' },
//     title: String,

//     fans: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Person' }]
//   });
  
//   var Story = mongoose.model('Story', storySchema);
//   var Person = mongoose.model('Person', personSchema);


//   var author = new Person({
//     _id: new mongoose.Types.ObjectId(),
//     name: 'Ian Fleming',
//     age: 50
//   });
  
//   author.save(function (err) {
//     if (err) return handleError(err);
  
//     var story1 = new Story({
//       title: 'Casino Royale',
//       author: author._id    // assign the _id from the person
//     });
  
//     story1.save(function (err) {
//       if (err) return handleError(err);
//       // thats it!
//     });
//   });


//   Story.
//   findOne({ title: 'Casino Royale' }).
//   populate('author').
//   exec(function (err, story) {
//     if (err) return handleError(err);
//     console.log('The author is %s', story.author.name);
  
//   });



Schema = mongoose.Schema,
autoIncrement = require('mongoose-auto-increment');
 
autoIncrement.initialize(db);





 
var bookSchema = new Schema({
    author: { type: Number, ref: 'Author' },
    title: String,
    genre: String,
    publishDate: Date
});
var authorSchema = new mongoose.Schema({
    name: String
});

bookSchema.plugin(autoIncrement.plugin, 
    {
        model: 'Book',
        startAt: 1000,
        incrementBy: 1
    }


);
authorSchema.plugin(autoIncrement.plugin, 
    {
        model: 'Author',
        startAt: 100,
        incrementBy: 2
    });

var Book = mongoose.model('Book', bookSchema);
var author = mongoose.model('Author', authorSchema);


var author1 = new author({
    name: "wenjun"
})
// author1.save(function(err){
//     if (err) return handleError(err);
    
//     var book1 = new Book({
//         author: author1._id,
//         title:"monogodb",
//         genre:"good",
//         publishDate: new Date()

//     })
//     book1.save(
//         function(err){
//             if (err){
//                 console.error(err)

//             }else{
//                 console.log('The book id  is %s', book1._id);
//             }
            

//         }
//     )


// })


Book.
  find({ title: 'monogodb' }).
  populate('author').
  exec(function (err, books) {
    // if (err) return handleError(err);
    // console.log('The author is %s', book.author.name);
    if (Array.isArray(books)){
        console.log(books[0].author.name)

    }else{

        console.log(books.author.name)
    }
  
  
  });
  console.log("test")
