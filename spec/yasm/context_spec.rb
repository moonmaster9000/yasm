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
        VendingMachine.state(:electricity) { start On }
        VendingMachine.state_configurations[:electricity].should_not be_nil
        VendingMachine.state_configurations[:electricity].start_state.should == On
      end

      it "should instance_eval the block on the new state configuration" do
        VendingMachine.state_configurations[:power].should be_nil
        class On; include Yasm::State; end
        VendingMachine.state(:power) { start On }
        VendingMachine.state_configurations[:power].should_not be_nil
        VendingMachine.state_configurations[:power].start_state.should == On
      end

      it "should create an instance method that returns the state" do
        class On; include Yasm::State; end
        VendingMachine.state(:light) { start On }
        VendingMachine.new.light.class.should == On
      end
    end
    
    describe "##start" do
      context "when called directly on the context" do
        it "should store the state as the start state of the anonymous state configuration" do
          VendingMachine.state_configurations[Yasm::Context::ANONYMOUS_STATE].should be_nil
          VendingMachine.start Waiting 
          VendingMachine.state_configurations[Yasm::Context::ANONYMOUS_STATE].start_state.should == Waiting
        end
      end
    end
    
    # describe "#do! instance method" do      
    #   it "should pass the context and all actions to the Yasm::Manager ##execute method" do
    #     vending_machine = VendingMachine.new
    #     Yasm::Manager.should_receive(:execute).with(:context => vending_machine, :actions => [InputMoney, Vend]).and_return nil
    #     vending_machine.do! InputMoney, Vend
    #   end
    # end
    
    # describe "##states class method" do
    #   context "called with arguments" do
    #     it "should verify that all of the parameters passed to it are classes that include Yasm::State" do
    #       proc { class VendingMachine; states Waiting; end}.should_not raise_exception
    #       proc { class VendingMachine; states Waiting, NotAState; end}.should raise_exception("You may only pass states that include Yasm::State to the `states` class method")
    #     end

    #     it "should store the states in the @states class instance variable" do
    #       class VendingMachine
    #         states Waiting, Vending
    #       end

    #       VendingMachine.states.should == [Waiting, Vending]
    #     end
    #   end

    #   context "called without arguments" do
    #     before do
    #       class VendingMachine
    #         states Waiting, Vending
    #       end
    #     end

    #     it "should return the possible states for the given class" do
    #       VendingMachine.states.should == [Waiting, Vending]
    #     end
    #   end
    # end

    # describe "#states instance method" do
    #   before do
    #     class VendingMachine
    #       states Waiting, Vending
    #     end
    #   end

    #   it "should not accept arguments" do
    #     proc { VendingMachine.new.states :argument }.should raise_exception(ArgumentError)
    #   end

    #   it "should return the same value as the class ##states method" do
    #     VendingMachine.new.states.should == VendingMachine.states
    #   end
    # end
  end
end
