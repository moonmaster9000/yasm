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
end
