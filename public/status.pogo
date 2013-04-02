status module = angular.module 'status' []

status module.factory 'refreshEvery' @($timeout)
    @(duration, block)
        block ()

        tick () = $timeout
            block ()
            tick ()
        (duration)

        tick ()

window.status controller ($scope, refresh every, $http) =
    build type = window.location.pathname.replace r/^\// ''
    console.log (build type)

    refresh every 1000
        $http(method: 'GET', url: "/status/#(build type)").success @(status)
            for @(field) in (status)
                if (status.has own property (field))
                    $scope.(field) = status.(field)

            status := status.status.to lower case ()
            $scope.status = status
            $scope.image =
                if (status == 'success')
                    'logical_awesome.jpeg'
                else
                    'fuuuu.jpeg'
