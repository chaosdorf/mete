%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  var/config.yaml
).each { |path| Spring.watch(path) }
