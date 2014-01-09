requirejs.config({
  shim: {
    'angular': { exports: 'angular' }
  },
  paths: {
    'angular': '/components/angular/angular.min',
    'angular-resource': '/components/angular-resource/angular-resource.min'
  }
});

require(
  [ 'angular', 'angular-resource' ],
  function (angular) {
    angular.module('pages', []);
    angular.bootstrap(document, ['pages']);
  }
);
