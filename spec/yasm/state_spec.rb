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
end
