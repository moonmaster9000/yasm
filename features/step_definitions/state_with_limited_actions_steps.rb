Given /^a state$/ do
  class StateWithLimitedActions
    include Yasm::State
  end
end

When /^I declare that only certain actions can be applied to it$/ do
  StateWithLimitedActions.actions :limited_action1, :limited_action2
end

Then /^those actions should be stored on the state class$/ do
  StateWithLimitedActions.allowed_actions.should == [:limited_action1, :limited_action2]
end

Given /^a state with limited actions$/ do
  StateWithLimitedActions.actions :limited_action1, :limited_action2
end

Then /^I should be able to determine whether a given action is valid for a given state$/ do
  class LimitedAction1; include Yasm::Action; end
  class LimitedAction2; include Yasm::Action; end
  class LimitedAction3; include Yasm::Action; end

  StateWithLimitedActions.is_allowed?(LimitedAction1).should be_true
  StateWithLimitedActions.is_allowed?(LimitedAction2).should be_true
  StateWithLimitedActions.is_allowed?(LimitedAction3).should be_false
end
