var emailService = require('./lib/email.js')();

emailService.send('wenjunma001@gmail.com', 'Hood River tours on sale today!',
    'Get \'em while they\'re hot!');


//
// const nodemailer = require('nodemailer');
//
// var auth = {
//     user: "advincenting@gmail.com",
//     pass: "ATB2afPG",
// };
//
// var mailOptions = {
//     from: 'advincenting@gmail.com',
//     to: 'wenjunma001@gmail.com',
//     subject: 'sample subject',
//     text: 'sample text',
//     html: '<b>sample html</b>',
// };
//
// var transporter = nodemailer.createTransport({
//     service: 'gmail',
//     auth: auth,
// });
//
// transporter.sendMail(mailOptions, (err, res) => {
//     if (err) {
//         return console.log(err);
//     } else {
//         console.log(JSON.stringify(res));
//     }
// });
