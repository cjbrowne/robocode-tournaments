module.exports = function ($scope, AuthService, $rootScope, $location) {
	// TODO: session handling

	$scope.flashMessage = false;
	$scope.flashIsError = false;
	$scope.showFlashMessage = false;

	if($location.path() == "/logout") {
		$scope.flashMessage = "You are now logged out.";
		$scope.flashIsError = false;
		$scope.showFlashMessage = true;
		$rootScope.loggedIn = false;
	}


	$scope.login = function () {
		$scope.flashMessage = false;
		$scope.flashIsError = false;
		AuthService.login({
			email: $scope.email,
			password: $scope.password
		}).success(function (data, status, headers, config) {
			$rootScope.loggedIn = data.loggedIn;
			if(data.loggedIn) {
				$location.path('/');
			} else {
				$scope.flashMessage = "Username or password incorrect.";
				$scope.flashIsError = true;
				$scope.showFlashMessage = true;
			}
		}).error(function (data, status, headers, config) {
			$scope.flashIsError = true;
			$scope.showFlashMessage = true;
			if(status == 418) {
				$scope.flashMessage = "You have been rate-limited.  Please wait 5 minutes before trying to login again.";
			} else if (status == 422) {
				$scope.flashMessage = "Please fill in your email and password to login.";
			} else {
				$scope.flashMessage = data.message || "Unknown error.";
			}
		});
	}

	$scope.register = function () {
		$scope.flashMessage = "";
		$scope.flashIsError = false;
		$scope.showFlashMessage = false;
		AuthService.register({
			email: $scope.email,
			password: $scope.password
		}).success(function (data, status, headers, config) {
			$scope.flashMessage = "Successfully registered user!  Please check your email for an activation link (although you can log in already)";
			$scope.flashIsError = false;
			$scope.showFlashMessage = true;
		}).error(function (data, status, headers, config) {
			$scope.flashIsError = true;
			$scope.showFlashMessage = true;
			if(status == 418) {
				$scope.flashMessage = "You have been rate-limited.  Please wait 5 minutes before trying to login again.";
			} else if (status == 422) {
				$scope.flashMessage = "Please fill in your desired email and password to register.";
			} else if (status == 409) {
				$scope.flashMessage = "That email address is already registered (try clicking login instead?)";
			} else {
				$scope.flashMessage = data.message || "Unknown error.";
			}
		});;

	}
	
}