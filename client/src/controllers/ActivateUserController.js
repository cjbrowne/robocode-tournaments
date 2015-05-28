module.exports = function ($scope, AuthService, $location) {
	$scope.finished = false;
	$scope.success = false;
	$scope.failure = false;
	$scope.failureReason = "Unknown";

	AuthService.activate({
		code: $location.search().code
	}).success(function (data, status, headers, config) {
		$scope.finished = true;
		$scope.success = true;
		$scope.failure = false;
		$scope.email = data.email;
	}).error(function (data, status, headers, config) {
		if(status == 404) {
			$scope.finished = true;
			$scope.success = false;
			$scope.failure = true;
			$scope.failureReason = "Activation Code not found.";
		}
	})
}