require 'spec_helper'

describe Yasm::Manager do
  describe "##execute" do
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

      class On
        include Yasm::State
        
        actions :unplug
      end

      class Off
        include Yasm::State
        
        actions :plug_in
      end
      
      @vending_machine = VendingMachine.new
    end
    
    it "should apply each action, sequentially, to the appropriate state_container within the context" do
      @vending_machine.state.value.class.should == On
      
      Yasm::Manager.execute :context => @vending_machine, :state_container => @vending_machine.state, :actions => [Unplug]
      @vending_machine.state.value.class.should == Off

      Yasm::Manager.execute :context => @vending_machine, :state_container => @vending_machine.state, :actions => [PlugIn]
      @vending_machine.state.value.class.should == On
    end

    it "should verify that the action is possible given the current state" do
      @vending_machine.state.value.class.should == On
      
      proc { 
        Yasm::Manager.execute(
          :context => @vending_machine, 
          :state_container => @vending_machine.state, 
          :actions => [PlugIn]
        )
      }.should raise_exception("We're sorry, but the action `PlugIn` is not possible given the current state `On`.")

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
