$LOAD_PATH.unshift './lib'
require 'yasm'
require 'rspec'
require 'rspec/mocks/standalone'
require 'couchrest_model'

COUCHDB_SERVER = CouchRest.new "http://admin:password@localhost:5984"
YASM_COUCH_DB = COUCHDB_SERVER.database!('yasm_test')
COUCHDB_SERVER.default_database = 'yasm_test'

Before('@couch') do
  YASM_COUCH_DB.recreate!
end
