# see https://github.com/blog/517-unicorn and
# https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-unicorn-and-nginx-on-ubuntu-14-04

# set path to application
app_dir = File.expand_path("../..", __FILE__)
working_directory app_dir

#set the environment
rails_env = ENV['RAILS_ENV'] || 'production'

# Set unicorn options
worker_processes 4
preload_app true
timeout 30

# Set up socket location
listen "#{app_dir}/unicorn.sock", :backlog => 64

# Set master PID location
pid "#{app_dir}/unicorn.pid"

# disable logging
stdout_path "/dev/null"
stderr_path "/dev/null"

# deployment
# shamelessly copied from https://gist.github.com/defunkt/206253


before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = "#{app_dir}/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end


after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  ActiveRecord::Base.establish_connection
end
