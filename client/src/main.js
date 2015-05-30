'use strict';
var angular = require('angular');

// controllers
var TournamentStandingsController = require('./controllers/TournamentStandingsController');
var LandingPageController = require('./controllers/LandingPageController');
var AddParticipantController = require('./controllers/AddParticipantController');
var ActivateUserController = require('./controllers/ActivateUserController');
var LoginController = require('./controllers/LoginController');
var NavController = require('./controllers/NavController');

// services
var ConfigService = require('./services/ConfigService');
var AuthService = require('./services/AuthService');
var RobotService = require('./services/RobotService');

angular.module('RobocodeTournament', [require('angular-route')])
	.factory('ConfigService', ConfigService)
	.factory('AuthService', AuthService)
	.factory('RobotService', RobotService)
	.controller('NavController', ['$scope', '$rootScope', NavController])
	.config(function ($routeProvider, $locationProvider) {

		$routeProvider
			.when('/', {
				controller: LandingPageController,
				templateUrl: 'templates/home.html'
			})
			.when('/standings', {
				controller: TournamentStandingsController,
				templateUrl: 'templates/standings.html'
			})
			.when('/robot', {
				controller: AddParticipantController,
				templateUrl: 'templates/upload.html'
			})
			.when('/login', {
				controller: LoginController,
				templateUrl: 'templates/login.html'
			})
			.when('/activate', {
				controller: ActivateUserController,
				templateUrl: 'templates/activate.html'
			})
			.when('/logout', {
				controller: LoginController,
				templateUrl: 'templates/login.html'
			})
			.otherwise({
				redirectTo: '/'
			});
	});