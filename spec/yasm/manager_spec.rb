require 'spec_helper'

describe Yasm::Manager do
  before do
    class VendingMachine
      include Yasm::Context
      
      start :on
    end

    class Unplug
      include Yasm::Action
      
      triggers :off
    end

    class PlugIn
      include Yasm::Action
      
      triggers :on
    end

    class Destroy
      include Yasm::Action

      triggers :destroyed
    end

    class On
      include Yasm::State
      
      actions :unplug, :destroy
    end

    class Off
      include Yasm::State
      
      actions :plug_in, :destroy
    end

    class Destroyed
      include Yasm::State

      final!
    end
    
    @vending_machine = VendingMachine.new
  end
    

  
  describe "##change_state" do
    it "should convert the state to a class if we pass an object that respond to :to_class" do
      Destroyed.should_receive(:to_class).and_return Destroyed
      Yasm::Manager.change_state :to => Destroyed, :on => @vending_machine.state
    end

    it "should set the instantiated_at property on the state to the current time" do
      seconds_since_the_epoch = Time.now
      Time.should_receive(:now).twice.and_return seconds_since_the_epoch 
      Yasm::Manager.change_state :to => On, :on => @vending_machine.state
      @vending_machine.state.value.instantiated_at.should == seconds_since_the_epoch
    end

    it "should raise an exception if the current state has not yet reached it's time limit" do
      class TenSeconds
        include Yasm::State

        minimum 10.seconds
      end

      proc {
        Yasm::Manager.change_state :to => TenSeconds, :on => @vending_machine.state
        Yasm::Manager.change_state :to => On, :on => @vending_machine.state
      }.should raise_exception(Yasm::TimeLimitNotYetReached, "We're sorry, but the time limit on the state `TenSeconds` has not yet been reached.")
    end
  end
  
  describe "##execute" do
    it "should apply each action, sequentially, to the appropriate state_container within the context" do
      @vending_machine.state.value.class.should == On
      
      Yasm::Manager.execute :context => @vending_machine, :state_container => @vending_machine.state, :actions => [Unplug]
      @vending_machine.state.value.class.should == Off

      Yasm::Manager.execute :context => @vending_machine, :state_container => @vending_machine.state, :actions => [PlugIn]
      @vending_machine.state.value.class.should == On
    end

    it "should raise an exception if you attempt to execute an action that isn't allowed by a state" do
      @vending_machine.state.value.class.should == On
      
      proc { 
        Yasm::Manager.execute(
          :context => @vending_machine, 
          :state_container => @vending_machine.state, 
          :actions => [PlugIn]
        )
      }.should raise_exception(Yasm::InvalidActionException, "We're sorry, but the action `PlugIn` is not possible given the current state `On`.")
    end

    it "should raise an exception if you attempt to execute an action on a final state." do
      proc {
        Yasm::Manager.execute(
          :context => @vending_machine,
          :state_container => @vending_machine.state,
          :actions => [Destroy, PlugIn]
        )
      }.should raise_exception(Yasm::FinalStateException, "We're sorry, but the current state `Destroyed` is final. It does not accept any actions.") 
    end
    
    it "should not raise an exception if the action is allowed by the state" do
      proc { 
        Yasm::Manager.execute(
          :context => @vending_machine, 
          :state_container => @vending_machine.state, 
          :actions => [Unplug]
        )
      }.should_not raise_exception
    end
  end
end
