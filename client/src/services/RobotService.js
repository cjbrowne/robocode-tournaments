module.exports = function ($http, ConfigService, AuthService) {
	var robotService = {};

	robotService.loadRobots = function () {
		var sessionId = sessionStorage.getItem('sessionId');
		if(!sessionId) {
			return null;
		}
		return $http.get(ConfigService.getApiUrl('/robot?sessionId=' + sessionId));
	}

	robotService.saveRobot = function (repoUrl, robot) {
		var sessionId = sessionStorage.getItem('sessionId');
		if(!sessionId) {
			return null;
		}
		return $http.put(ConfigService.getApiUrl('/robot?sessionId=' + sessionId), {
			repoUrl: repoUrl,
			robot: robot
		});
	}

	return robotService;
}