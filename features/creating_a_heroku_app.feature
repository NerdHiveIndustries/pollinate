@disable-bundler
Feature: Creating a Heroku app when pollinating a project

  Scenario: User uses the --heroku=true command line argument
    When I pollinate a project called "test_project" with:
      | argument | value |
      | --heroku | true  |
    Then the "test_project-staging" heroku app should exist
    And the "test_project-production" heroku app should exist
