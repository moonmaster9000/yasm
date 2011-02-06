require 'spec_helper'

describe Yasm::Context do
  context "when included in a class" do
    before do
      class VendingMachine
        include Yasm::Context
      end

      class Waiting
        include Yasm::State
      end
    end
    
    describe "##state" do
      it "should require something that can be converted to a symbol" do
        proc { VendingMachine.state(nil) }.should raise_exception(ArgumentError, "The state name must respond to `to_sym`")
      end

      it "should create a new state configuration" do
        VendingMachine.state_configurations[:electricity].should be_nil
        class On; include Yasm::State; end
        VendingMachine.state(:electricity) { start :on }
        VendingMachine.state_configurations[:electricity].should_not be_nil
        VendingMachine.state_configurations[:electricity].start_state.should == :on
      end

      it "should instance_eval the block on the new state configuration" do
        VendingMachine.state_configurations[:power].should be_nil
        class On; include Yasm::State; end
        VendingMachine.state(:power) { start :on }
        VendingMachine.state_configurations[:power].should_not be_nil
        VendingMachine.state_configurations[:power].start_state.should == :on
      end

      it "should create an instance method that returns the state" do
        class On; include Yasm::State; end
        VendingMachine.state(:light) { start :on }
        VendingMachine.new.light.state.class.should == On
      end
    end
    
    describe "##start" do
      context "when called directly on the context" do
        it "should store the state as the start state of the anonymous state configuration" do
          VendingMachine.state_configurations[Yasm::Context::ANONYMOUS_STATE].should be_nil
          VendingMachine.start :waiting 
          VendingMachine.state_configurations[Yasm::Context::ANONYMOUS_STATE].start_state.should == :waiting
        end
      end
    end
  end
end
