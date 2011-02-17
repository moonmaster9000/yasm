Feature: 
  As a programmer
  I want to declare a state as FINAL
  So that I can forbid any futher actions or state transitions

  Scenario: Declaring a state FINAL
    Given a state that I intend to declare final
    When I declare it final
    Then it should return true when asked if it's a FINAL state

  Scenario: Applying an action to a FINAL state
    Given a final state
    When I attempt to apply an action to it
    Then I should get an exception
