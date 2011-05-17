Given /^a context with a state$/ do
  class ContextWithState
    include Yasm::Context
    start :some_state
  end

  class SomeState
    include Yasm::State
  end
  @context_with_state = ContextWithState.new
end

Then /^I should be able to access the context from the state$/ do
  @context_with_state.state.value.context.should == @context_with_state
end
