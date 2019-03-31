
var nodemailer = require('nodemailer');

// https://service.exmail.qq.com/cgi-bin/help?subtype=1&&id=28&&no=1000585
var config = {
    host: 'smtp.exmail.qq.com',
    secureConnection: true,
    port: 465,
    secure: true,
    auth: {
        user: 'admin@51alp.com',
        pass: 'FXSUMfM7ZHcwhynA'
    }
};





var transporter = nodemailer.createTransport(config);


function send(mail){
    transporter.sendMail(mail, function(error, info){
        if(error) {
            return console.log(error);
        }
        console.log('mail sent:', info.response);
    });
};

// 创建一个邮件对象
var mail = {
    // 发件人
    from: 'admin<admin@51alp.com>',
    // 主题
    subject: '新用户注册成功',
    // 收件人
    to: '76547664@qq.com',
    // 邮件内容，HTML格式
    text: '感谢使用'
};
send(mail);
