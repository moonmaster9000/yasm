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
    gemspec.add_dependency('activesupport', '~> 3.0')
    gemspec.add_dependency('i18n', '~> 0.5.0')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
