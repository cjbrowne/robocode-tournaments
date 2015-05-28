var nodemailer = require('nodemailer');
var smtpTransport = require('nodemailer-smtp-transport');
var jade = require('jade');

var config = require('./config');
var fs = require('fs');

var emailTemplate = fs.readFileSync('./templates/email.jade');

// function to return a config parameter from config without triggering an error if it
// or any parent keys are missing
// using a fancy recursive algorithm because fuck maintenance I guess
var safeGetConfig = function (key, cnf) {
	var keys = key.split('.');
	if(!cnf) return safeGetConfig(key, config);
	if(!cnf[keys[0]]) {
		return null;
	} else {
		if (keys.length > 1) {
			return safeGetConfig(key, cnf[keys[0]]);
		} else {
			return cnf[keys[0]];
		}
	}
}

var transporter = nodemailer.createTransport(smtpTransport({
	host: safeGetConfig('mail.exchange.host'),
	port: safeGetConfig('mail.exchange.port')
}));

module.exports = function (to, activationCode) {

	var mailOptions = {
	    from: config.mail.fromAddress, 
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