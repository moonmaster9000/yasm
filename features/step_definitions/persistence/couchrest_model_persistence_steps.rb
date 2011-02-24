Given /^a class that inherits from CouchRest::Model::Base$/ do
  class TestYasmCouchPersistence < CouchRest::Model::Base
  end
end

When /^I mix Yasm::Context into it$/ do
  TestYasmCouchPersistence.include Yasm::Context
end

Then /^Yasm::Persistence::CouchRest::Model should be autoincluded as well$/ do
  TestYasmCouchPersistence.ancestors.should be_include(Yasm::Persistence::CouchRest::Model)
end
