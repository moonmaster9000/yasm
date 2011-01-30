require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "yasm"
    gemspec.summary     = "Yet Another State Machine. Pronounced \"yaz-um.\""
    gemspec.description = "Breaks up states, actions, and contexts into seperate classes." + 
    gemspec.email       = "moonmaster9000@gmail.com"
    gemspec.files       = FileList['lib/**/*.rb', 'README.rdoc', 'VERSION', 'yasm.gemspec']
    gemspec.homepage    = "http://github.com/moonmaster9000/yasm"
    gemspec.authors     = ["Matt Parker"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
