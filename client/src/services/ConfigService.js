// TODO: work out how to make this configurable at run and/or compile time.

module.exports = function ($http) {
	const BASE_URL = "http://localhost:8000";
	var configService = {};


	configService.getApiUrl = function (endpoint) {
		if(endpoint[0] === '/')
			return BASE_URL + endpoint;
		else
			return BASE_URL + '/' + endpoint;
	}

	return configService;
}