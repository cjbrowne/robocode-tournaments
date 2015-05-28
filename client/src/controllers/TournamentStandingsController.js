module.exports = function ($scope) {
	function generateTestTier(boutCount) {
		var i, testTier = [];
		for(i = 0; i < boutCount; i++) {
			testTier.push({
				resolved: false,
				participants: [
					{
						name: 'foo',
						author: 'bar'
					},
					{
						// HAXX
					},
					{
						name: 'baz',
						author: 'inga'
					}
				],
				class: 'bout'
			});
			// HAX
			testTier.push({
				class: 'spacer'
			});
		}
		return testTier;
	}
	$scope.tiers = [
		generateTestTier(16),
		generateTestTier(8),
		generateTestTier(4),
		generateTestTier(2),
		generateTestTier(1)
	];
}