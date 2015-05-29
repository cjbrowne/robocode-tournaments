var nodemailer = require('nodemailer');
var smtpTransport = require('nodemailer-smtp-transport');
var jade = require('jade');

var config = require('./config');
var fs = require('fs');

var emailTemplate = fs.readFileSync('./templates/email.jade');

// function to return a config parameter from config without triggering an error if it
// or any parent keys are missing
// using a fancy recursive algorithm because fuck maintenance I guess
var safeGetConfig = require('./configHelper');

var transporter = nodemailer.createTransport(smtpTransport({
	host: safeGetConfig('mail.exchange.host'),
	port: safeGetConfig('mail.exchange.port'),
	secure: false,
	ignoreTLS: true,
	debug: true
}));

module.exports = function (to, activationCode) {

	var mailOptions = {
	    from: safeGetConfig('mail.fromAddress'), 
	    to: to.split(',')[0], 
	    subject: 'Robocode Tournament requires activation!',
	    html: jade.compile(emailTemplate)({
	    	activationCode: activationCode,
	    	baseUrl: config.baseUrl
	    })
	};

	transporter.sendMail(mailOptions, function(error, info){
	    if(error){
	        return console.log(error);
	    }
	    console.log('Message sent: ' + info.response);

	});

}