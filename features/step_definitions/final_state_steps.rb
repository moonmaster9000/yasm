Given /^a state that I intend to declare final$/ do
  class FinalState; include Yasm::State; end
  FinalState.final?.should be_false
end

When /^I declare it final$/ do
  FinalState.final!
end

Then /^it should return true when asked if it's a FINAL state$/ do
  FinalState.final?.should be_true
end

Given /^a final state$/ do
  class ContextWithFinalState
    include Yasm::Context
    start :final_state
  end

  class FinalState
    include Yasm::State
    final!
  end
  @context = ContextWithFinalState.new
end

When /^I attempt to apply an action to it$/ do
  class ImpossibleAction; include Yasm::Action; end
  @apply_action = proc {@context.do! ImpossibleAction}
end

Then /^I should get an exception$/ do
  @apply_action.should raise_exception(Yasm::FinalStateException)
end
