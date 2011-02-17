Feature: Actions
  As a programmer
  I want to be able to apply actions to a state
  So that I can cause the state to transition

  Scenario: Applying actions to a state
  Given a context
  When I apply an action to it that triggers a state transition
  Then the state should transition appropriately
