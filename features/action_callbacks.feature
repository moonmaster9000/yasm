Feature: Action Callbacks
  As a programmer
  I want to have before and after hooks into actions
  So that I can customize my state machine

  Scenario: After Action callback
    Given a context that I intend to attach action callbacks to
    When I create an after action callback with no constraints
    Then that callback should be called after all actions
    When I create an after action callback with an `only` constraint
    Then that callback should be called only when the particular action(s) run
    When I create an after action callback with an `except` constraint
    Then that callback should not be called when the particular action(s) run 

  Scenario: Before Action callback
    Given a context that I intend to attach before action callbacks to
    When I create a before action callback with no constraints
    Then that callback should be called before all actions
    When I create a before action callback with an `only` constraint
    Then that before callback should be called only when the particular action(s) run
    When I create a before action callback with an `except` constraint
    Then that before callback should not be called when the particular action(s) run 
