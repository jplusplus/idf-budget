'use strict'

describe 'Directive: landscape', () ->

  # load the directive's module
  beforeEach module 'idfBudgetApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<landscape></landscape>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the landscape directive'
