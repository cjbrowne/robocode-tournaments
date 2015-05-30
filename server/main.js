// TODO: more than one file?

var express = require('express');

var app = express();
var bodyParser = require('body-parser');
var pg = require('pg');
// TODO: replace 'config' uses with the config helper (safeGetConfig)
var config = require('./config');
var _ = require('lodash-node');
var crypto = require('crypto');
var sendmail = require('./sendmail');
var safeGetConfig = require('./configHelper');

// use CRUD verbs for db operations
var query = {
	// is read_participants actually used?
	read_participants: '\
			SELECT author.name AS author_name, participant.name AS name \
				FROM participant \
				INNER JOIN author \
					ON (participant.author = author.id)',
	create_author: '\
			INSERT INTO author (name, email, secret, activation_code) VALUES($1::text, $1::text, $2::text, $3::text)\
			',
	activate_author:'\
			UPDATE author SET activated=TRUE\
			WHERE\
				activation_code = $1::text\
			RETURNING\
				activated,\
				email\
			',
	authenticate_user: '\
			SELECT id\
				FROM author\
				WHERE email=$1\
					AND secret=$2\
			',
	fetch_robots: '\
			SELECT class, repo\
				FROM participant\
				WHERE author = $1::integer\
			',
	update_robots: '\
			INSERT INTO participant (repo, class, author)\
				SELECT $1::text, $2::text, $3::integer\
				WHERE NOT EXISTS (\
						SELECT * FROM participant WHERE author = $3::integer\
					)\
			'
			/*
			;\
			UPDATE participant\
				SET repo = $1::text, class = $2::text\
				WHERE author = $3::integer\
	'*/
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
});
app.use(function (req, res, next) {
	res.header('Access-Control-Allow-Origin', config.allowOrigin || '*');
	res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
	res.header('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE');
	next();
});

// some useful functions
var hashPassword = function (password) {
	var hasher = crypto.createHash('sha512');

	// suggestion: set prePasswordSalt and postPasswordSalt to long, high-entropy random strings.
	hasher.update(config.prePasswordSalt);
	hasher.update(password);
	hasher.update(config.postPasswordSalt);
	
	return hasher.digest('base64');
}

var requestCount = {};

var rateLimit = function (maxTries, req, res, resource) {
	// coerce null to a number
	requestCount[req.ip] = requestCount[req.ip] || 0;
	requestCount[req.ip]++;
	// after a minute, remove this attempt
	setTimeout(function () {
		requestCount[req.ip]--;
	}, 60000);
	if(requestCount[req.ip] && requestCount[req.ip] > 15) {
		// rate limit those fuckers
		res.status(418).send({
			swaghetti: 'yolonaise',
			mother: 'fucker',
			message: 'Too many ' + resource + ' attempts.  Please wait 5 minutes before trying again.'
		});
		return true;
	}
	return false;
}

pg.connect(config.pg_connection_string, function (err, client, done) {
	if(err) {
		console.log('pg error',err);
		return;
	}

	// for simplicity's sake, just an in-memory hashtable of sessions (won't work at scale but this whole project won't work at scale)
	var sessions = {};

	setInterval(function () {
		var now = Date.now();

		_.each(sessions, function (session, sessionId) {
			// sessionTimeout is specified in minutes
			if(now - session.lastActive > (config.sessionTimeout * 60000)) {
				delete sessions[sessionId];
			}
		});

	// there's no reason to run this too often
	}, 10000);

	app.use(function (req, res, next) {
		var session;
		if(req.query.sessionId) {
			session = sessions[req.query.sessionId];
			if(sessions[req.query.sessionId]) {
				session.lastActive = Date.now();
			}
		}
		
		next();
	});

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
		return crypto.randomBytes(64).toString('base64').replace(/\//g,'_').replace(/\+/g,'-').replace(/\=/g,'');
	}

	var generateSessionId = function () {
		return crypto.randomBytes(16).toString('hex');
	}

	// activate author *idempotently*
	app.post('/activate', function (req, res) {
		if (rateLimit(safeGetConfig('rateLimit.activate', 3), req, res, 'activation')) return;
		if(req.body.code) {
			client.query(query.activate_author, [
				req.body.code
			], function (err, result) {
				if(err) {
					res.status(500).send({
						message:'Postgres error',
						details: err
					});
				} else {
					if(result.rows.length == 0) {
						res.status(404).send({
							message: 'User not found',
							details: null
						});
					} else {
						res.status(200).send({
							activated: result.rows[0].activated,
							email: result.rows[0].email
						});
					}
				}
			});
		}
	});


	// register new user
	app.post('/register', function (req, res) {
		var activationCode;
		if(rateLimit(safeGetConfig('rateLimit.register', 5), req, res, 'registration')) return;
		
		if(req.body.email && req.body.password) {
			activationCode = generateActivationCode();
			client.query(query.create_author, [
				req.body.email,
				hashPassword(req.body.password),
				activationCode
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
					sendmail(req.body.email, activationCode);
					// user successfully created
					res.status(201).send({});
				}
			});
		} else {
			res.status(422).send({
				message: 'Missing credentials'
			});
		}
	});

	// login
	app.post('/login', function (req, res) {
		if(!req.body.password || !req.body.email) {
			res.status(422).send({
				message: 'Missing credentials'
			});
			return;
		}
		var passwordHash = hashPassword(req.body.password);
		if(rateLimit(safeGetConfig('rateLimit.login', 5), req, res, 'login')) return;
		client.query(query.authenticate_user, [
				req.body.email,
				passwordHash
			],function (err, result) {
			if(err) {
				// I'm not being funny or anything, but leaking ANYTHING
				// at this stage is a *really* bad idea so not even development
				// builds should get details on errors at this point
				res.status(500).send({
					error: 'Postgres error',
					details: null
				});
			} else {
				if(result.rows.length == 0) {
					// for hysterical raisins the client expects a 200 on failed login requests
					res.status(200).send({
						loggedIn: false
					});
				} else {
					var sessionId = generateSessionId();
					sessions[sessionId] = {
						authorId: result.rows[0].id,
						// we kind of don't need to keep the email hanging around, but I see no reason not to either
						email: req.body.email,
						lastActive: Date.now()
					};
					res.status(200).send({
						loggedIn: true,
						sessionId: sessionId
					});	
				}
			}
		})
	});

	app.get('/robot', function (req, res) {
		var sessionId = req.query.sessionId,
			session;
		if(sessionId && sessions[sessionId]) {
			session = sessions[sessionId];
			client.query(query.fetch_robots, [
				session.authorId
				], function (err, result) {
					var repoUrl, robots, repoUrlResultRow;
					if(err) {
						res.status(500).send({
							messsage: 'Postgres error',
							details: err
						});
					} else {
						robots = _.filter(result.rows, function (row) {
							return !!row.class;
						});
						if(robots.length > 1) {
							console.warn('More than one robot found for user: ', session.email);
						} else if (robots.length == 0) {
							robot = "";
						} else {
							robot = robots[0].class;
						}
						repoUrlResultRow = _.find(result.rows, function (row) {
							return !!row.repo;
						});
						repoUrl = (repoUrlResultRow && repoUrlResultRow.repo) || "";
						res.send({
							robot: robot,
							repoUrl: repoUrl
						});
					}
				});
		} else {
			res.status(401).send({
				message: 'Not authorized',
				reason: sessionId ? 'Session timeout' : 'Not logged in'
			});
		}
	});

	app.put('/robot', function (req, res) {
		var sessionId = req.query.sessionId,
			session;
		if(sessionId && sessions[sessionId]) {
			session = sessions[sessionId];
			client.query(query.update_robots, [
				req.body.repoUrl,
				req.body.robot,
				session.authorId
				], function (err, result) {
					if(err) {
						res.status(500).send({
							messsage: 'Postgres error',
							details: err
						});
					} else {
						res.status(200).send({
							repoUrl: req.body.repoUrl,
							robot: req.body.robot
						});
					}
				});
		} else {
			res.status(401).send({
				message: 'Not authorized',
				reason: sessionId ? 'Session timeout' : 'Not logged in'
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

