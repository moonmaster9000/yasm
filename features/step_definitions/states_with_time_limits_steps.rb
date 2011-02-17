Given /^a state that I intend to declare a minimum time limit on$/ do
  class StateWithMinimumTimeLimit
    include Yasm::State
  end
  StateWithMinimumTimeLimit.minimum_duration.should be_nil
end

When /^I declare a minimum time limit on it$/ do
  StateWithMinimumTimeLimit.minimum 10.minutes
end

Then /^it should store that time limit on the state class$/ do
  StateWithMinimumTimeLimit.minimum_duration.should == 10.minutes
end

Given /^a state that has a minimum time limit$/ do
  class ContextWithStateWithMinimumTimeLimit
    include Yasm::Context
    start :state_with_minimum_time_limit
  end

  class StateWithMinimumTimeLimit
    include Yasm::State
    minimum 10.minutes
  end

  @context = ContextWithStateWithMinimumTimeLimit.new
end

When /^I apply an action to that state before its minimum time limit has been reached$/ do
  class ActionOnStateWithMinimumTimeLimit
    include Yasm::Action
  end
  
  @apply_action = proc {@context.do! ActionOnStateWithMinimumTimeLimit}
end

Then /^I should get a minimum time limit exception$/ do
  @apply_action.should raise_exception(Yasm::TimeLimitNotYetReached)
end

When /^I apply an action to that state after its minimum time limit has been reached$/ do
  @apply_action = proc {
    ten_minutes_from_now = 10.minutes.from_now
    Time.stub(:now).and_return ten_minutes_from_now
    @context.do! ActionOnStateWithMinimumTimeLimit
  }
end

Then /^I should not get a minimum time limit exception$/ do
  @apply_action.should_not raise_exception 
end

Given /^a state that I intend to declare a maximum time limit on$/ do
  class StateWithMaxTimeLimit
    include Yasm::State
  end
end

When /^I declare a maximum time limit on it without an action$/ do
  @declaration = proc {
    StateWithMaxTimeLimit.maximum 10.minutes
  }
end

Then /^it should raise an argument error exception$/ do
  @declaration.should raise_error(ArgumentError)
end

When /^I declare a maximum time limit on it with an action$/ do
  @declaration = proc {
    StateWithMaxTimeLimit.maximum 10.minutes, :action => :max_time_limit_action
  }
  class MaxTimeLimitAction; include Yasm::Action; end
end

Then /^it should store that maximum time limit and action on the state class$/ do
  @declaration.should_not raise_error
  StateWithMaxTimeLimit.maximum_duration.should == 10.minutes
  StateWithMaxTimeLimit.maximum_duration_action.should == MaxTimeLimitAction
end

Given /^a context with the potential for a max time limit dominoe effect$/ do
  class DominoContext
    include Yasm::Context

    start :domino1
  end
  
  class Domino1
    include Yasm::State
    
    actions :trigger_domino2
    maximum 10.minutes, :action => :trigger_domino2
  end

  class TriggerDomino2
    include Yasm::Action

    triggers :domino2
  end

  class Domino2
    include Yasm::State

    maximum 10.minutes, :action => :trigger_domino3
  end

  class TriggerDomino3
    include Yasm::Action

    triggers :domino3
  end

  class Domino3
    include Yasm::State
  end

  class TriggerDomino4
    include Yasm::Action

    triggers :domino4
  end

  class Domino4
    include Yasm::State
  end
end

When /^I wait long enough to cause the dominoe effect$/ do
  @wait = proc {
    @context = DominoContext.new
    @context.state.value
    thirty_minutes_from_now = 30.minutes.from_now
    Time.stub(:now).and_return thirty_minutes_from_now
  }
end

Then /^the dominoe effect should occur when I ask for the state$/ do
  @wait.call
  @context.state.value.class.should == Domino3
end

Then /^the dominoe effect should occur when I attempt to apply an action to the context$/ do
  @context.do! TriggerDomino4
  @context.state.value.class.should == Domino4
end
