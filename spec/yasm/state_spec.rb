require 'spec_helper'

describe Yasm::State do
  before do
    class TestState
      include Yasm::State
    end

    class Action1; include Yasm::Action; end
    class Action2; include Yasm::Action; end
  end

  describe "##actions" do 
    it "should set the @allowed_actions to the input to this method" do
      TestState.actions Action1, Action2 
      TestState.allowed_actions.should == [Action1, Action2]
    end
  end

  describe "##final!" do
    it "should set the @allowed_actions to an empty array" do
      TestState.final!
      TestState.allowed_actions.should == []
    end
  end

  describe "##final?" do
    it "should return true if there are no allowed actions" do
      TestState.final!
      TestState.final?.should be_true
    end
  end

  describe "##minimum" do
    it "should require an integer" do
      proc { TestState.minimum "10 minutes" }.should raise_exception("You must provide a Fixnum to the ##minimum method (represents number of seconds). For example: 2.minutes")
    end
    
    it "should set the @state_minimum_duration to the number input" do
      TestState.minimum 1.minute
      TestState.minimum_duration.should == 60
    end
  end

  describe "#reached_minimum_time_limit?" do
    before do
      class MinState
        include Yasm::State
      end
    end

    it "should return true if there is no minimum time limit for the state" do
      MinState.new.reached_minimum_time_limit?.should be_true 
    end

    it "should return false if there is a time limit that hasn't been reached yet" do
      MinState.minimum 10.seconds
      state = MinState.new
      state.instantiated_at = Time.now
      state.reached_minimum_time_limit?.should be_false
    end

    it "should return true if the state has reached it's time limit" do
      MinState.minimum 10.seconds
      state = MinState.new
      state.instantiated_at = Time.now
      ten_seconds_from_now = 10.seconds.from_now
      Time.should_receive(:now).and_return ten_seconds_from_now
      state.reached_minimum_time_limit?
    end
  end

  describe "##maximum" do
    it "should require both a time limit and an action" do
      proc { TestState.maximum }.should raise_exception(ArgumentError)
      proc { TestState.maximum 10.seconds }.should raise_exception(ArgumentError)
      proc { TestState.maximum 10.seconds, :action => :action1 }.should_not raise_exception
    end

    it "should store the time limit and action" do
      TestState.maximum 20.seconds, :action => :action2
      TestState.maximum_duration.should == 20.seconds
      TestState.maximum_duration_action.should == Action2
    end
  end

  describe "##passed_maximum_time_limit?" do
    it "should return false if no time limit has been set" do
      class UnlimitedState
        include Yasm::State
      end

      UnlimitedState.new.passed_maximum_time_limit?.should be_false
    end

    it "should return true if a time limit was set, and that limit has been passed" do
      class LimitedState
        include Yasm::State

        maximum 10.seconds, :action => :action2
      end

      s = LimitedState.new
      s.instantiated_at = Time.now
      ten_seconds_from_now = 10.seconds.from_now
      Time.stub!(:now).and_return ten_seconds_from_now
      s.passed_maximum_time_limit?.should be_true
    end
  end
end
