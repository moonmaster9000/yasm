require 'spec_helper'

describe Yasm::Manager do
  describe "##execute" do
    before do
      class VendingMachine
        include Yasm::Context
        start On
      end
      class On; include Yasm::State; end
      class Off; include Yasm::State; end
      class Unplug; include Yasm::Action; triggers Off; end
      class PlugIn; include Yasm::Action; triggers On; end
      
      @vending_machine = VendingMachine.new
    end
    
    it "should apply each action, sequentially, to the appropriate state_container within the context" do
      @vending_machine.state.value.class.should == On
      
      Yasm::Manager.execute :context => @vending_machine, :state_container => @vending_machine.state, :actions => [Unplug]
      @vending_machine.state.value.class.should == Off

      Yasm::Manager.execute :context => @vending_machine, :state_container => @vending_machine.state, :actions => [PlugIn]
      @vending_machine.state.value.class.should == On
    end
  end
end
