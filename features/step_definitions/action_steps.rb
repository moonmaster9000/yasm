Given /^a context$/ do
  class ActionFeatureContext
    include Yasm::Context

    start :action_feature_state_1
  end

  class ActionFeatureState1
    include Yasm::State
  end

  class ActionFeatureState2
    include Yasm::State
  end

  @context = ActionFeatureContext.new
  @context.state.value.class.should == ActionFeatureState1
end

When /^I apply an action to it that triggers a state transition$/ do
  class TriggerActionFeatureState2
    include Yasm::Action

    triggers :action_feature_state_2
  end
  @context.do! TriggerActionFeatureState2
end

Then /^the state should transition appropriately$/ do
  @context.state.value.class.should == ActionFeatureState2
end
