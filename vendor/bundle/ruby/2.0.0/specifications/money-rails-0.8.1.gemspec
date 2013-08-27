# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "money-rails"
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andreas Loupasakis", "Shane Emmons", "Simone Carletti"]
  s.date = "2013-05-07"
  s.description = "This library provides integration of RubyMoney - Money gem with Rails"
  s.email = ["alup.rubymoney@gmail.com"]
  s.homepage = "https://github.com/RubyMoney/money-rails"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Money gem integration with Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<money>, ["~> 5.1.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<railties>, [">= 3.0"])
      s.add_development_dependency(%q<rails>, [">= 3.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.10"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0.8.0"])
    else
      s.add_dependency(%q<money>, ["~> 5.1.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<railties>, [">= 3.0"])
      s.add_dependency(%q<rails>, [">= 3.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.10"])
      s.add_dependency(%q<database_cleaner>, [">= 0.8.0"])
    end
  else
    s.add_dependency(%q<money>, ["~> 5.1.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<railties>, [">= 3.0"])
    s.add_dependency(%q<rails>, [">= 3.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.10"])
    s.add_dependency(%q<database_cleaner>, [">= 0.8.0"])
  end
end
