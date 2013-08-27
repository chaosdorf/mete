# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "money"
  s.version = "5.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tobias Luetke", "Hongli Lai", "Jeremy McNevin", "Shane Emmons", "Simone Carletti"]
  s.date = "2013-02-20"
  s.description = "This library aids one in handling money and different currencies."
  s.email = ["semmons99+RubyMoney@gmail.com"]
  s.homepage = "http://rubymoney.github.com/money"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.0.3"
  s.summary = "Money and currency exchange support library."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<i18n>, ["~> 0.6.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8.1"])
      s.add_development_dependency(%q<kramdown>, ["~> 0.14.0"])
    else
      s.add_dependency(%q<i18n>, ["~> 0.6.0"])
      s.add_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_dependency(%q<yard>, ["~> 0.8.1"])
      s.add_dependency(%q<kramdown>, ["~> 0.14.0"])
    end
  else
    s.add_dependency(%q<i18n>, ["~> 0.6.0"])
    s.add_dependency(%q<rspec>, ["~> 2.11.0"])
    s.add_dependency(%q<yard>, ["~> 0.8.1"])
    s.add_dependency(%q<kramdown>, ["~> 0.14.0"])
  end
end
