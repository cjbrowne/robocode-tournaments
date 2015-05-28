module.exports = function ($scope, $rootScope) {
	$scope.loggedIn = false;
	$rootScope.$watch('loggedIn', function (loggedIn) {
		$scope.loggedIn = loggedIn;
	});
	
}