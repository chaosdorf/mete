# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "haml-rails"
  s.version = "0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andr\u{e9} Arko"]
  s.date = "2013-02-14"
  s.description = "Haml-rails provides Haml generators for Rails 3. It also enables Haml as the templating engine for you, so you don't have to screw around in your own application.rb when your Gemfile already clearly indicated what templating engine you have installed. Hurrah."
  s.email = ["andre@arko.net"]
  s.homepage = "http://github.com/indirect/haml-rails"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "haml-rails"
  s.rubygems_version = "2.0.3"
  s.summary = "let your Gemfile do the configuring"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<haml>, ["< 4.1", ">= 3.1"])
      s.add_runtime_dependency(%q<activesupport>, ["< 4.1", ">= 3.1"])
      s.add_runtime_dependency(%q<actionpack>, ["< 4.1", ">= 3.1"])
      s.add_runtime_dependency(%q<railties>, ["< 4.1", ">= 3.1"])
      s.add_development_dependency(%q<rails>, ["< 4.1", ">= 3.1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<haml>, ["< 4.1", ">= 3.1"])
      s.add_dependency(%q<activesupport>, ["< 4.1", ">= 3.1"])
      s.add_dependency(%q<actionpack>, ["< 4.1", ">= 3.1"])
      s.add_dependency(%q<railties>, ["< 4.1", ">= 3.1"])
      s.add_dependency(%q<rails>, ["< 4.1", ">= 3.1"])
      s.add_dependency(%q<bundler>, ["~> 1.2"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<haml>, ["< 4.1", ">= 3.1"])
    s.add_dependency(%q<activesupport>, ["< 4.1", ">= 3.1"])
    s.add_dependency(%q<actionpack>, ["< 4.1", ">= 3.1"])
    s.add_dependency(%q<railties>, ["< 4.1", ">= 3.1"])
    s.add_dependency(%q<rails>, ["< 4.1", ">= 3.1"])
    s.add_dependency(%q<bundler>, ["~> 1.2"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
