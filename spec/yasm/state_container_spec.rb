require 'spec_helper'

describe Yasm::Context::StateContainer do
  before do
    class VendingMachine
      include Yasm::Context
    end

    class Waiting
      include Yasm::State
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
  end
end
