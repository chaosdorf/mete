# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "raindrops"
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["raindrops hackers"]
  s.date = "2013-04-20"
  s.description = "Raindrops is a real-time stats toolkit to show statistics for Rack HTTP\nservers.  It is designed for preforking servers such as Rainbows! and\nUnicorn, but should support any Rack HTTP server under Ruby 1.9, 1.8 and\nRubinius on platforms supporting POSIX shared memory.  It may also be\nused as a generic scoreboard for sharing atomic counters across multiple\nprocesses."
  s.email = "raindrops@librelist.org"
  s.extensions = ["ext/raindrops/extconf.rb"]
  s.extra_rdoc_files = ["README", "LICENSE", "NEWS", "ChangeLog", "lib/raindrops.rb", "lib/raindrops/aggregate.rb", "lib/raindrops/aggregate/last_data_recv.rb", "lib/raindrops/aggregate/pmq.rb", "lib/raindrops/last_data_recv.rb", "lib/raindrops/linux.rb", "lib/raindrops/middleware.rb", "lib/raindrops/middleware/proxy.rb", "lib/raindrops/struct.rb", "lib/raindrops/watcher.rb", "ext/raindrops/raindrops.c", "ext/raindrops/linux_inet_diag.c", "ext/raindrops/linux_tcp_info.c"]
  s.files = ["README", "LICENSE", "NEWS", "ChangeLog", "lib/raindrops.rb", "lib/raindrops/aggregate.rb", "lib/raindrops/aggregate/last_data_recv.rb", "lib/raindrops/aggregate/pmq.rb", "lib/raindrops/last_data_recv.rb", "lib/raindrops/linux.rb", "lib/raindrops/middleware.rb", "lib/raindrops/middleware/proxy.rb", "lib/raindrops/struct.rb", "lib/raindrops/watcher.rb", "ext/raindrops/raindrops.c", "ext/raindrops/linux_inet_diag.c", "ext/raindrops/linux_tcp_info.c", "ext/raindrops/extconf.rb"]
  s.homepage = "http://raindrops.bogomips.org/"
  s.rdoc_options = ["-t", "raindrops - real-time stats for preforking Rack servers", "-W", "http://bogomips.org/raindrops.git/tree/%s"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "rainbows"
  s.rubygems_version = "2.0.3"
  s.summary = "real-time stats for preforking Rack servers"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<aggregate>, ["~> 0.2"])
      s.add_development_dependency(%q<io-extra>, [">= 1.2.3", "~> 1.2"])
      s.add_development_dependency(%q<posix_mq>, ["~> 2.0"])
      s.add_development_dependency(%q<rack>, ["~> 1.2"])
      s.add_development_dependency(%q<unicorn>, [">= 0.98"])
    else
      s.add_dependency(%q<aggregate>, ["~> 0.2"])
      s.add_dependency(%q<io-extra>, [">= 1.2.3", "~> 1.2"])
      s.add_dependency(%q<posix_mq>, ["~> 2.0"])
      s.add_dependency(%q<rack>, ["~> 1.2"])
      s.add_dependency(%q<unicorn>, [">= 0.98"])
    end
  else
    s.add_dependency(%q<aggregate>, ["~> 0.2"])
    s.add_dependency(%q<io-extra>, [">= 1.2.3", "~> 1.2"])
    s.add_dependency(%q<posix_mq>, ["~> 2.0"])
    s.add_dependency(%q<rack>, ["~> 1.2"])
    s.add_dependency(%q<unicorn>, [">= 0.98"])
  end
end
