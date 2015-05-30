module.exports = function ($scope, $rootScope, RobotService) {

	$scope.doneLoading = false;
	$scope.robot = '';
	$scope.saveButtonEnabled = false;


	var loadRobotPromise = RobotService.loadRobots();
	if(loadRobotPromise) {
		$scope.flashMessage = "";
		$scope.showFlashMessage = false;
		$scope.flashIsErrorMessage = false;
		loadRobotPromise
			.success(function (data, status, headers, config) {
				$scope.repoUrl = data.repoUrl;
				$scope.robot = data.robot;
				$scope.doneLoading = true;
				$scope.saveButtonEnabled = true;
			})
			.error(function (data, status, headers, config) {
				if(status == 401) {
					$scope.flashMessage = "You have been logged out due to inactivity.  Please log in again.";
					$scope.showFlashMessage = true;
					$scope.flashIsErrorMessage = true;
					sessionStorage.removeItem('sessionId');
					$rootScope.loggedIn = false;
				} else {
					$scope.flashMessage = "An unknown error occurred trying to load the robot data.  Please wait a few moments, and try again.";
					$scope.showFlashMessage = true;
					$scope.flashIsErrorMessage = true;
				}
			});
	} else {
		$scope.flashMessage = "You must be logged in to perform this action. (sessionid missing)";
		$scope.showFlashMessage = true;
		$scope.flashIsErrorMessage = true;
	}

	$scope.save = function () {
		$scope.saveButtonEnabled = false;
		RobotService.saveRobot($scope.repoUrl, $scope.robot).success(function () {
			$scope.saveButtonEnabled = true;
			$scope.repoUrl = data.repoUrl;
			$scope.robot = data.robot;
		});
	}
}