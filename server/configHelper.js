var config = require('./config');

module.exports = function safeGetConfig(key, defaultValue, cnf) {
	var keys = key.split('.');
	if(!cnf) return safeGetConfig(key, defaultValue, config);
	if(!cnf[keys[0]]) {
		return defaultValue;
	} else {
		if (keys.length > 1) {
			return safeGetConfig(key, defaultValue, cnf[keys[0]]);
		} else {
			return cnf[keys[0]];
		}
	}
}