require 'spec_helper'

describe Yasm::Manager do
  describe "##execute" do
    it "should require a hash parameter" do
      proc { Yasm::Manager.execute }.should raise_exception(ArgumentError)
      proc { Yasm::Manager.execute :not_a_hash}.should raise_exception("You must pass a hash to ##execute")
      proc { Yasm::Manager.execute({})}.should_not raise_exception("You must pass a hash to ##execute")
    end

    it "should require a valid context" do
      proc { Yasm::Manager.execute :context => :invalid_context }.should raise_exception("You must pass a valid context to ##execute")
      proc { Yasm::Manager.execute :context => VendingMachine.new }.should_not raise_exception("You must pass a valid context to ##execute")
    end

    it "should verify that the actions are Yasm::Action's" do
       proc { Yasm::Manager.execute :context => VendingMachine.new, :actions => [InputMoney, NotAnAction] }.should raise_exception("You must pass classes or instances that have Yasm::Action as an ancestor to ##execute")
    end

    it "should apply each action, sequentially, to the context" do
    end
  end
end
