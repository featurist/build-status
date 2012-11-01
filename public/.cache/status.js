(function() {
    var self = this;
    var statusModule;
    statusModule = angular.module("status", []);
    statusModule.factory("refreshEvery", function($timeout) {
        return function(duration, block) {
            var tick;
            block();
            tick = function() {
                return $timeout(function() {
                    block();
                    return tick();
                }, duration);
            };
            return tick();
        };
    });
    window.statusController = function($scope, refreshEvery, $http) {
        var self = this;
        return refreshEvery(1e3, function() {
            return $http({
                method: "GET",
                url: "/status/bt2"
            }).success(function(status) {
                var field;
                for (field in status) {
                    (function(field) {
                        if (status.hasOwnProperty(field)) {
                            $scope[field] = status[field];
                        }
                    })(field);
                }
                status = status.status.toLowerCase();
                $scope.status = status;
                return $scope.image = function() {
                    if (status === "success") {
                        return "logical_awesome.jpeg";
                    } else {
                        return "fuuuu.jpeg";
                    }
                }();
            });
        });
    };
}).call(this);