var config = require('./config');

module.exports = function safeGetConfig(key, defaultValue, cnf) {
	if(!cnf) return safeGetConfig(key, defaultValue, config);
	var keys = key.split('.');
	var current_key = keys.shift();
	// TODO: proper logging framework instead of commenting out trace/debug logs
	//console.log('key: ' + key + '\n' + 'default: ' + defaultValue + '\n' + 'cnf: ' + JSON.stringify(cnf) + '\n');
	if(!cnf[current_key]) {
		return defaultValue;
	} else {
		if (keys.length > 0) {
			return safeGetConfig(keys.join('.'), defaultValue, cnf[current_key]);
		} else {
			return cnf[current_key];
		}
	}
}