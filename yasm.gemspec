Gem::Specification.new do |s|
  s.name = %q{yasm}
  s.version = File.read "VERSION"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Parker"]
  s.date = %q{2011-02-23}
  s.description = %q{Breaks up states, actions, and contexts into seperate classes.moonmaster9000@gmail.com}
  s.email = %q{moonmaster9000@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
 
  s.homepage = %q{http://github.com/moonmaster9000/yasm}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Yet Another State Machine. Pronounced "yaz-um."}
  
  s.add_dependency(%q<activesupport>, ["~> 3.0"])
  s.add_dependency(%q<i18n>, ["~> 0.5.0"])
  s.add_development_dependency(%q<couchrest_model>, [">= 0"])
  s.add_development_dependency(%q<cucumber>, ["~> 0.10.0"])
end
