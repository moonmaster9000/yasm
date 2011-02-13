require 'spec_helper'

describe Yasm::Context::StateContainer do
  before do
    class VendingMachine
      include Yasm::Context

      start :waiting
    end

    class Waiting
      include Yasm::State
    end
    
    class Hit
      include Yasm::Action

      triggers :jammed
    end

    class Jammed
      include Yasm::State
      
      maximum 10.seconds, :action => :explode
    end

    class Exploded
      include Yasm::State

      actions :clean_up
    end

    class CleanUp
      include Yasm::Action
    end

    class Explode
      include Yasm::Action
    end

    class InputMoney
      include Yasm::Action
    end
  end

  describe "#do!" do
    it "should pass the actions off to the Yasm::Manager.execute method" do
      v = VendingMachine.new
      Yasm::Manager.should_receive(:execute).with(:context => v, :state_container => v.state, :actions => [InputMoney, InputMoney])
      v.state.do! InputMoney, InputMoney
    end

    it "should add the maximum action to the front of the action list if the maximum time limit has been reached" do
      v = VendingMachine.new
      v.do! Hit
      Yasm::Manager.should_receive(:execute).with(:context => v, :state_container => v.state, :actions => [Explode, CleanUp]) 
      time = 10.seconds.from_now
      Time.stub!(:now).and_return time
      v.do! CleanUp
    end
  end
end
