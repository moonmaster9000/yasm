Given /^a class that inherits from CouchRest::Model::Base$/ do
  class TestYasmCouchPersistence < CouchRest::Model::Base
  end
end

When /^I mix Yasm::Context into it$/ do
  class TestYasmCouchPersistence
    include Yasm::Context
  end
end

Then /^Yasm::Persistence::CouchRest::Model should be autoincluded as well$/ do
  TestYasmCouchPersistence.ancestors.should be_include(Yasm::Persistence::CouchRest::Model)
end

Given /^a couchrest model context$/ do
  class CouchContext < CouchRest::Model::Base
    use_database YASM_COUCH_DB
    include Yasm::Context

    start :couch_state1
  end
  class CouchState1
    include Yasm::State
  end
  class CouchState2
    include Yasm::State
  end
  class GoToState2
    include Yasm::Action
    triggers :couch_state2
  end
  @couch_context = CouchContext.new
end

When /^I save that context to CouchDB$/ do
  @couch_context.do! GoToState2
  @state_start_time = @couch_context.state.value.instantiated_at
  @couch_context.save
end

Then /^the states should be saved in the document$/ do
  @doc = YASM_COUCH_DB.get @couch_context.id
  @doc["yasm"].should_not be_nil
  @doc["yasm"]["states"][Yasm::Context::ANONYMOUS_STATE.to_s].should_not be_nil
  @doc["yasm"]["states"][Yasm::Context::ANONYMOUS_STATE.to_s]["class"].should == "CouchState2"
  Time.parse(@doc["yasm"]["states"][Yasm::Context::ANONYMOUS_STATE.to_s]["instantiated_at"]).to_s.should == @state_start_time.to_s
end

Given /^a couchrest model context with state saved in the database$/ do
  class CouchContext < CouchRest::Model::Base
    include Yasm::Context

    start :couch_state1
  end
  class CouchState1; include Yasm::State; end
  class CouchState2
    include Yasm::State

    maximum 9.minutes, :action => :go_to_state3
  end
  class CouchState3
    include Yasm::State
  end
  class GoToState2; include Yasm::Action; triggers :couch_state2; end
  class GoToState3; include Yasm::Action; triggers :couch_state3; end
  @couch_context = CouchContext.new 
  @couch_context.do! GoToState2
  @state_start_time = @couch_context.state.value.instantiated_at
  @couch_context.save
end

When /^I load that context$/ do
  ten_minutes_from_now = 10.minutes.from_now
  Time.stub(:now).and_return ten_minutes_from_now
  @couch_context = CouchContext.get @couch_context.id
end

Then /^the states should be restored$/ do
  @couch_context.state.value.class.should == CouchState3
end

Then /^the states should be fast forwarded$/ do
  @couch_context.state.value.class.should == CouchState3
end
