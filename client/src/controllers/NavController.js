module.exports = function ($scope, $rootScope) {
	$scope.loggedIn = false;
	$rootScope.$watch('loggedIn', function (loggedIn) {
		$scope.loggedIn = loggedIn;
	});
	$scope.init = function () {
		var potentialSessionId = sessionStorage.getItem('sessionId');
		if (potentialSessionId) {
			$rootScope.loggedIn = true;
		}
	}
}