requirejs.config({
  shim: {
    'angular': { exports: 'angular' },
    "angular-resource": {
      deps: ["angular"]
    }
  },
  paths: {
    'angular': '/components/angular/angular',
    'angular-resource': '/components/angular-resource/angular-resource'
  }
});

require(
  [ 'angular', 'angular-resource' ],
  function (ng) {
    ng.module('pagination', ['ngResource']);
    ng.module('pagination').
      factory('paginated-resource', ['$resource', function(resource) {
        return function (url, params, actions) {
          actions = ng.extend(actions || {}, {
            query: {
              isArray: true,
              method: 'GET',
              headers: {
                'Range-Unit': 'items',
                'Range': '0-9'
              }
            }
          });

          return resource(url, params, actions);
        };
      }]).
      controller('FunCtrl', ['$scope', 'paginated-resource', function(scope, resource) {
        scope.alphabet = resource('/alphabet').query();
        scope.integers = resource('/integers').query();
      }]);

    ng.bootstrap(document, ['pagination']);
  }
);
