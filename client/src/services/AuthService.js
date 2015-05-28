module.exports = function ($http, ConfigService) {
	var authService = {};

	authService.login = function (credentials) {
		// configservice will build a url for us based on the resource we are interested in
		var loginUrl = ConfigService.getApiUrl('/login');
		return $http
			.post(loginUrl, credentials);
	}

	authService.register = function (credentials) {
		var registerUrl = ConfigService.getApiUrl('/register');
		return $http
			.post(registerUrl, credentials);
	}

	authService.activate = function (activationOptions) {
		var activateUrl = ConfigService.getApiUrl('/activate');
		return $http
			.post(activateUrl, activationOptions);
	}
	
	return authService;
}