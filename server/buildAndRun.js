var config = require('./config');
var safeGetConfig = require('./configHelper');
var pg = require('pg');
var when = require('when');
var _ = require('lodash-node');
var Git = require('nodegit');
var child_process = require('child_process');
var rimraf = require('rimraf');
var fs = require('fs');
var glob = require('glob');

var query = {
	fetch_robots: '\
		SELECT class, repo, id\
			FROM participant\
		',
	update_build_status: '\
		UPDATE participant\
			SET build_status = $1::text\
			WHERE id = $2::integer\
		'
}

module.exports = function buildAndRun() {
	var self = this;
	pg.connect(config.pg_connection_string, function (err, client, done) {
		if(err) {
			console.log('pg error',err);
			return;
		}

		var setBuildStatus = function (status, id) {
			return when.promise(function (resolve, reject) {

				client.query(query.update_build_status, [status, id], function (err, result) {
					if(err) {
						console.log('Postfix error: ', err);
					}
					resolve();
				});
			});
		}

		var recursiveBuildRobot = function (buildQueue, onAllRobotsBuilt) {
			var robot = buildQueue.shift();
			var wdPath = __dirname + '/workspace/' + robot.class;
			console.log('building', robot.class);

			var nextRobot = function () {
				if(buildQueue.length > 0) {
					recursiveBuildRobot(buildQueue, onAllRobotsBuilt);
				} else {
					onAllRobotsBuilt();
				}
			}

			rimraf.sync(wdPath);

			Git.Clone(robot.repo, 'workspace/' + robot.class)
				.then(function (repository) {
					var mavenProcess = child_process.spawn('mvn', ['install'], {
						cwd: wdPath,
						stdio: 'inherit'
					});
					mavenProcess.on('close', function (code) {
						if(code != 0) {
							console.log('maven error', code);
							setBuildStatus('FAILED_MAVEN', robot.id).then(nextRobot);
						} else {
							// for now, this is it.  We will add more tests later
							glob(wdPath + '/target/*.jar', function (err, jarFiles) {
								if(jarFiles.length > 1) {
									console.log('ambiguous jars');
									setBuildStatus('FAILED_JAR', robot.id).then(nextRobot);
								} else {
									if(!fs.existsSync('tournament')) {
										fs.mkdirSync('tournament');
									}
									fs.createReadStream(jarFiles[0]).pipe(fs.createWriteStream('tournament/' + robot.class + '.jar'));
									console.log('build passing', robot);
									setBuildStatus('SUCCESS', robot.id).then(nextRobot);
								}
							});
						}
					})
				}, function (err) {
					console.log('git clone error', err);
					setBuildStatus('FAILED_GIT', robot.id).then(nextRobot);
				});
		}

		var buildRobots = function () {
			return when.promise(function (resolve, reject) {
				var robotBuildQueue = [];
				client.query(query.fetch_robots, function (err, result) {
					if(err) {
						reject(err);
					} else {
						// in lieu of pluck working *like it should*, we have to write the much less readable alternative
						// because fuck logic, and fuck readability
						// robotBuildQueue = _.pluck(result.rows, 'class','repo');
						robotBuildQueue = _.map(result.rows,_.partialRight(_.pick,['class','repo', 'id']));
						recursiveBuildRobot(robotBuildQueue, resolve);
					}
				})
			});
		}

		var runTournament = function () {
			glob('tournament/*.jar', function (err, files) {

			});
			done();
		}
		var rawTournamentTime = safeGetConfig('tournament.start');
		var tournamentTime = new Date();
		// TODO: fucking validation and some other shit
		tournamentTime.setHours(rawTournamentTime.split(':')[0]);
		tournamentTime.setMinutes(rawTournamentTime.split(':')[1]);
		var tournamentFrequency = safeGetConfig('tournament.frequency');

		var shouldRunToday = function (today) {
			if(tournamentFrequency == 'daily') {
				return true;
			} else if (
				tournamentFrequency == 'weekly' &&
				// TODO: have it configurable which day of the week to run on
				today.getDay() == 5) {
				return true;
			} else if (
				tournamentFrequency == 'monthly' &&
				// TODO: have it configurable which day of the month to run on
				today.getDate() == 25) {
				return true;
			} else {
				// TODO: validate config (instead of silently never running the competition if you fuck up)
				return false;
			}
		}

		console.log('building robots...');
		buildRobots()
			.then(function () {
				var now = new Date();
				if( shouldRunToday(now) &&
					tournamentTime.getHours() == now.getHours() &&
					tournamentTime.getMinutes() == now.getMinutes()
					) {

					runTournament();
				}
				setTimeout(_.bind(buildAndRun, self, client), safeGetConfig('build.frequency', 1) * 60000);
			});
	});
}