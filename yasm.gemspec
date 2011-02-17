# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{yasm}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Parker"]
  s.date = %q{2011-02-17}
  s.description = %q{Breaks up states, actions, and contexts into seperate classes.moonmaster9000@gmail.com}
  s.email = %q{moonmaster9000@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "VERSION",
    "lib/yasm.rb",
    "lib/yasm/action.rb",
    "lib/yasm/context.rb",
    "lib/yasm/context/anonymous_state_identifier.rb",
    "lib/yasm/context/state_configuration.rb",
    "lib/yasm/context/state_container.rb",
    "lib/yasm/conversions.rb",
    "lib/yasm/conversions/class.rb",
    "lib/yasm/conversions/symbol.rb",
    "lib/yasm/exceptions.rb",
    "lib/yasm/exceptions/final_state_exception.rb",
    "lib/yasm/exceptions/invalid_action_exception.rb",
    "lib/yasm/exceptions/time_limit_not_yet_reached.rb",
    "lib/yasm/manager.rb",
    "lib/yasm/state.rb",
    "lib/yasm/version.rb",
    "yasm.gemspec"
  ]
  s.homepage = %q{http://github.com/moonmaster9000/yasm}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Yet Another State Machine. Pronounced "yaz-um."}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_runtime_dependency(%q<i18n>, ["~> 0.5.0"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_dependency(%q<i18n>, ["~> 0.5.0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0"])
    s.add_dependency(%q<i18n>, ["~> 0.5.0"])
  end
end

