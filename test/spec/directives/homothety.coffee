'use strict'

describe 'Directive: homothety', () ->

  # load the directive's module
  beforeEach module 'idfBudgetApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
