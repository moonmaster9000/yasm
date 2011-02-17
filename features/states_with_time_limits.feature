Feature: Time limits on states
  As a programmer
  I want to be able to put minimum and maximum time limits on states
  So that I can simulate better the real world

  Scenario: Declaring a minimum time limit
    Given a state that I intend to declare a minimum time limit on
    When I declare a minimum time limit on it
    Then it should store that time limit on the state class

  Scenario: Applying an action to a state with a minimum time limit
    Given a state that has a minimum time limit
    When I apply an action to that state before its minimum time limit has been reached
    Then I should get a minimum time limit exception
    When I apply an action to that state after its minimum time limit has been reached
    Then I should not get a minimum time limit exception

  Scenario: Declaring a maximum time limit
    Given a state that I intend to declare a maximum time limit on
    When I declare a maximum time limit on it without an action
    Then it should raise an argument error exception
    When I declare a maximum time limit on it with an action
    Then it should store that maximum time limit and action on the state class

  Scenario: State transition dominoe with max time limits
    Given a context with the potential for a max time limit dominoe effect
    When I wait long enough to cause the dominoe effect
    Then the dominoe effect should occur when I ask for the state
    And the dominoe effect should occur when I attempt to apply an action to the context
