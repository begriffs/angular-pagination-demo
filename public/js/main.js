requirejs.config({
  shim: {
    'angular': { exports: 'angular' }
  },
  paths: {
    angular: '/components/angular/angular.min'
  }
});

require(
  [
    'angular'
  ],
  function (angular) {
    angular.module('pages', []);
    angular.bootstrap(document, ['pages']);
  }
);
