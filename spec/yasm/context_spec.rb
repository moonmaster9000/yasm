require 'spec_helper'

describe Yasm::Context do
  context "when included in a class" do
    before do
    end

    describe "#do! instance method" do      
      it "should pass the context and all actions to the Yasm::Manager ##execute method" do
        vending_machine = VendingMachine.new
        Yasm::Manager.should_receive(:execute).with(:context => vending_machine, :actions => [InputMoney, Vend]).and_return nil
        vending_machine.do! InputMoney, Vend
      end
    end
    
    describe "##states class method" do
      context "called with arguments" do
        it "should verify that all of the parameters passed to it are classes that include Yasm::State" do
          proc { class VendingMachine; states Waiting; end}.should_not raise_exception
          proc { class VendingMachine; states Waiting, NotAState; end}.should raise_exception("You may only pass states that include Yasm::State to the `states` class method")
        end

        it "should store the states in the @states class instance variable" do
          class VendingMachine
            states Waiting, Vending
          end

          VendingMachine.states.should == [Waiting, Vending]
        end
      end

      context "called without arguments" do
        before do
          class VendingMachine
            states Waiting, Vending
          end
        end

        it "should return the possible states for the given class" do
          VendingMachine.states.should == [Waiting, Vending]
        end
      end
    end

    describe "#states instance method" do
      before do
        class VendingMachine
          states Waiting, Vending
        end
      end

      it "should not accept arguments" do
        proc { VendingMachine.new.states :argument }.should raise_exception(ArgumentError)
      end

      it "should return the same value as the class ##states method" do
        VendingMachine.new.states.should == VendingMachine.states
      end
    end
  end
end
