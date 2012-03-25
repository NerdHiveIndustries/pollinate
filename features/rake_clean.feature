@disable-bundler
Feature: Rake works in the pollinated project

  Scenario: Running rake in the pollinated project
    When I pollinate a project called "test_project"
    And I cd to the "test_project" root
    When I drop and create the required databases
    And I run the rake task "db:create"
    And I run the rake task "db:migrate"
    And I run the rake task "db:test:prepare"
    And I run the rake task "cucumber"
    Then I see a successful response in the shell

  Scenario: Making a spec then running rake
    When I drop and create the required databases
    And I pollinate a project called "test_project"
    And I generate "model post title:string"
    And I run the rake task "db:migrate"
    And I run the rake task "db:test:prepare"
    And I run the rake task "spec"
    Then I see a successful response in the shell
