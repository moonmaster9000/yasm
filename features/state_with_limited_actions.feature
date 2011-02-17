Feature: State's that limit actions
  As a programmer
  I want to limit the actions that can be applied to a state
  So that I can control the workflow of my state machine

  Scenario: Declaring valid actions
    Given a state
    When I declare that only certain actions can be applied to it
    Then those actions should be stored on the state class

  Scenario: Determing if an action is valid for a given state
    Given a state with limited actions
    Then I should be able to determine whether a given action is valid for a given state
