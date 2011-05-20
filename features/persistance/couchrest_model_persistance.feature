@couch
Feature: CouchRest::Model Persistance
  As a CouchDB hacker
  I want the states on my CouchRest::Mode::Base context persisted to CouchDB
  So that I can incorporate YASM into my relaxing database environment

  Scenario: Yasm::Persistence::CouchRest::Model should be auto included when Yasm::Context is included inside a CouchRest::Model::Base derived class
    Given a class that inherits from CouchRest::Model::Base
    When I mix Yasm::Context into it
    Then Yasm::Persistence::CouchRest::Model should be autoincluded as well

  Scenario: Saving state to CouchRest::Model::Base derived classes
    Given a couchrest model context
    When I save that context to CouchDB
    Then the states should be saved in the document

  @focus
  Scenario Outline: Loading state from CouchRest::Model::Base derived classes
    Given a couchrest model context with state saved in the database
    When I load that context via "<method>"
    Then the states should be restored
    And the states should be fast forwarded

    Examples:
      |method|
      |get|
      |find|
      |by_user|
