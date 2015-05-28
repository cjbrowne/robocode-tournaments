var express = require('express');

var app = express();
var bodyParser = require('body-parser');
var pg = require('pg');
var config = require('./config');
var _ = require('lodash-node');
var crypto = require('crypto');

// use CRUD verbs for db operations
var query = {
	read_participants: '\
			SELECT authors.name AS author_name, participants.name AS name \
				FROM participants \
				INNER JOIN authors \
					ON (participants.author = authors.id)',
	create_author: '\
			INSERT INTO authors (name, email, activation_code) VALUES($1::text, $2::text, $3::text)'
};

// even though we might never start listening, best to prepare the app above any logic
app.use(bodyParser.json());
app.use(function (err, req, res, next) {
	// catch bodyParser.json parse errors
	if(err instanceof SyntaxError) {
		res.status(400).send({
			message: 'JSON parse error',
			details: null
		});
	} else {
		next();
	}
})

pg.connect(config.pg_connection_string, function (err, client, done) {
	if(err) {
		console.log('pg error',err);
		return;
	}
	var sendPGResult = function (req, res) {
		return function (err, result) {
			if(err) {
				res.status(500)
					.send({
						message:'Postgres error',
						details: err
					});
			} else {
				if(!result) {
					res.send({});
				} else {
					res.send(result.rows);
				}
			}
		}
	}

	app.get('/participants', function (req, res) {
		client.query(query.read_participants, sendPGResult(req, res));
	});

	var generateActivationCode = function () {
		return crypto.randomBytes(64).toString('base64').replace(/\//g,'_').replace(/\+/g,'-');
	}

	// register new author
	app.post('/author', function (req, res) {
		if(req.body.email) {
			client.query(query.create_author, [
				req.body.name, 
				req.body.email, 
				generateActivationCode()
				], function (err, result) {
				if(err) {
					if(err.constraint) {
						if(err.constraint == "unique_email") {
							res.status(409).send({
								message: 'User exists',
								details: null
							});
						} else if (err.constraint == "unique_activation_code") {
							// although this case is extremely rare, it is worth handling to save
							// future confusion in the event that it actually happens
							// P = 1 / 2^64 (or approx. once every twenty quintillion registration attempts)
							res.status(503).setHeader('Retry-After', '0').send({
								message: 'Temporary failure (activation code duplicate found); you may retry immediately',
								details: null
							});
						}
					} else {
						res.status(500).send({
							message:'Postgres error',
							details: err
						});
					}
				} else {
					res.status(200).send({});
				}
			});
		}
	});

	app.get('/', function (req, res) {
		var baseUrl = req.protocol + '://' + req.get('host');
		res.send({
			participants: baseUrl + '/participants',
			standings: baseUrl + '/standings'
		});
	});

	app.get('*', function (req, res) {
		res.status(400).send({
			error: 'Resource not found: ' + req.originalUrl
		});
	});

	app.listen(8000);
});
