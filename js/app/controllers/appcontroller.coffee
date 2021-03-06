###

ownCloud - News

@author Alessandro Cosentino
@copyright 2013 Alessandro Cosentino cosenal@gmail.com

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
License as published by the Free Software Foundation; either
version 3 of the License, or any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU AFFERO GENERAL PUBLIC LICENSE for more details.

You should have received a copy of the GNU Affero General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

###


angular.module('Tasks').controller 'AppController',
['$scope', 'Persistence', '$route', 'Status', '$timeout',
'$location', '$routeParams', 'Loading',
($scope, Persistence, $route, status, $timeout, $location,
$routeParams, Loading) ->

	class AppController

		constructor: (@_$scope, @_persistence, @_$route, @_$status,
			@_$timeout, @_$location, @_$routeparams, @_Loading) ->

			@_$scope.initialized = false

			@_$scope.status = @_$status.getStatus()

			@_$scope.route = @_$routeparams

			@_$scope.status.newListName = ""

			successCallback = =>
				@_$scope.initialized = true

			@_persistence.init().then(successCallback)

			@_$scope.closeAll = () ->
				if _$scope.status.searchActive
					_$location.path('/search/'+_$scope.route.searchString)
				else
					_$location.path('/lists/'+_$scope.route.listID)

				_$scope.status.addingList = false
				_$scope.status.focusTaskInput = false
				_$scope.status.newListName = ""

			@_$scope.isLoading = () ->
				return _Loading.isLoading()

	return new AppController($scope, Persistence, $route, status, $timeout,
	$location, $routeParams, Loading)

]