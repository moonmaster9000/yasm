class BeforeActionCallbackContext
  include Yasm::Context
  start :action_callback_state
end

class ActionCallbackContext
  include Yasm::Context
  start :action_callback_state
end

class ActionCallbackState
  include Yasm::State
end

class Action1; include Yasm::Action; end
class Action2; include Yasm::Action; end
class Action3; include Yasm::Action; end
class Action4; include Yasm::Action; end

Given /^a context that I intend to attach action callbacks to$/ do
end

When /^I create an after action callback with no constraints$/ do
  class ActionCallbackContext
    attr_accessor :counter
    after_action :increment_counter

    def initialize
      @counter = 0
    end

    private
    def increment_counter
      @counter += 1
    end
  end
end

Then /^that callback should be called after all actions$/ do
  context = ActionCallbackContext.new
  context.counter.should == 0
  context.do! Action1
  context.counter.should == 1
  context.do! Action2
  context.counter.should == 2
  context.do! Action3
  context.counter.should == 3
  context.do! Action4
  context.counter.should == 4
end

When /^I create an after action callback with an `only` constraint$/ do
  class ActionCallbackContext
    after_action :decrement_counter, :only => [:action1, :action2]

    private
    def decrement_counter
      @counter -= 1
    end
  end
end

Then /^that callback should be called only when the particular action\(s\) run$/ do
  context = ActionCallbackContext.new
  context.counter.should == 0
  context.do! Action1
  context.counter.should == 0
  context.do! Action2
  context.counter.should == 0
  context.do! Action3
  context.counter.should == 1
  context.do! Action4
  context.counter.should == 2 
end

When /^I create an after action callback with an `except` constraint$/ do
  class ActionCallbackContext
    after_action :double_counter, :except => :action3

    private
    def double_counter
      @counter *= 2
    end
  end
end

Then /^that callback should not be called when the particular action\(s\) run$/ do
  context = ActionCallbackContext.new
  context.counter.should == 0
  context.do! Action3
  context.counter.should == 1
  context.do! Action3
  context.counter.should == 2
  context.do! Action4
  context.counter.should == 6
  context.do! Action4
  context.counter.should == 14
  context.do! Action1
  context.counter.should == 28
end


Given /^a context that I intend to attach before action callbacks to$/ do
end

When /^I create a before action callback with no constraints$/ do
  class BeforeActionCallbackContext
    attr_accessor :counter
    before_action :increment_counter

    def initialize
      @counter = 0
    end

    private
    def increment_counter
      @counter += 1
    end
  end
end

Then /^that callback should be called before all actions$/ do
  context = BeforeActionCallbackContext.new
  context.counter.should == 0
  context.do! Action1
  context.counter.should == 1
  context.do! Action2
  context.counter.should == 2
  context.do! Action3
  context.counter.should == 3
  context.do! Action4
  context.counter.should == 4
end

When /^I create a before action callback with an `only` constraint$/ do
  class BeforeActionCallbackContext
    before_action :decrement_counter, :only => [:action1, :action2]

    private
    def decrement_counter
      @counter -= 1
    end
  end
end

Then /^that before callback should be called only when the particular action\(s\) run$/ do
  context = BeforeActionCallbackContext.new
  context.counter.should == 0
  context.do! Action1
  context.counter.should == 0
  context.do! Action2
  context.counter.should == 0
  context.do! Action3
  context.counter.should == 1
  context.do! Action4
  context.counter.should == 2 
end

When /^I create a before action callback with an `except` constraint$/ do
  class BeforeActionCallbackContext
    before_action :double_counter, :except => :action3

    private
    def double_counter
      @counter *= 2
    end
  end
end

Then /^that before callback should not be called when the particular action\(s\) run$/ do
  context = BeforeActionCallbackContext.new
  context.counter.should == 0
  context.do! Action3
  context.counter.should == 1
  context.do! Action3
  context.counter.should == 2
  context.do! Action4
  context.counter.should == 6
  context.do! Action4
  context.counter.should == 14
  context.do! Action1
  context.counter.should == 28
end
