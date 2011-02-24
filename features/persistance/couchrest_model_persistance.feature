Feature: CouchRest::Model Persistance
  As a CouchDB hacker
  I want the states on my CouchRest::Mode::Base context persisted to CouchDB
  So that I can incorporate YASM into my relaxing database environment

  Scenario: Yasm::Persistence::CouchRest::Model should be auto included when Yasm::Context is included inside a CouchRest::Model::Base derived class
    Given a class that inherits from CouchRest::Model::Base
    When I mix Yasm::Context into it
    Then Yasm::Persistence::CouchRest::Model should be autoincluded as well
