'use strict';
var angular = require('angular');

var TournamentStandingsController = require('./controllers/TournamentStandingsController');
var LandingPageController = require('./controllers/LandingPageController');
var AddParticipantController = require('./controllers/AddParticipantController');

angular.module('RobocodeTournament', [require('angular-route')])
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
			.when('/upload', {
				controller: AddParticipantController,
				templateUrl: 'templates/upload.html'
			})
			.otherwise({
				redirectTo: '/'
			});
	});