# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "twitter-bootstrap-rails"
  s.version = "2.2.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Seyhun Akyurek"]
  s.date = "2013-08-07"
  s.description = "twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline"
  s.email = ["seyhunak@gmail.com"]
  s.homepage = "https://github.com/seyhunak/twitter-bootstrap-rails"
  s.post_install_message = "Important: You may need to add a javascript runtime to your Gemfile in order for bootstrap's LESS files to compile to CSS. \n\n**********************************************\n\nExecJS supports these runtimes:\n\ntherubyracer - Google V8 embedded within Ruby\n\ntherubyrhino - Mozilla Rhino embedded within JRuby\n\nNode.js\n\nApple JavaScriptCore - Included with Mac OS X\n\nMicrosoft Windows Script Host (JScript)\n\n**********************************************\n"
  s.require_paths = ["lib"]
  s.rubyforge_project = "twitter-bootstrap-rails"
  s.rubygems_version = "2.0.3"
  s.summary = "Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.1"])
      s.add_runtime_dependency(%q<execjs>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, [">= 3.1"])
      s.add_development_dependency(%q<less>, [">= 0"])
      s.add_development_dependency(%q<therubyracer>, ["= 0.11.1"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<railties>, [">= 3.1"])
      s.add_dependency(%q<actionpack>, [">= 3.1"])
      s.add_dependency(%q<execjs>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.1"])
      s.add_dependency(%q<less>, [">= 0"])
      s.add_dependency(%q<therubyracer>, ["= 0.11.1"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1"])
    s.add_dependency(%q<actionpack>, [">= 3.1"])
    s.add_dependency(%q<execjs>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.1"])
    s.add_dependency(%q<less>, [">= 0"])
    s.add_dependency(%q<therubyracer>, ["= 0.11.1"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
