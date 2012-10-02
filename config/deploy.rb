require 'bundler/capistrano'

set :application, "mete"
set :deploy_to, "/srv/http/mete"
set :repository,  "https://github.com/nomaster/mete"
set :scm, :git
set :use_sudo, false
set :user, "http"

role :app, "hyperion.chaosdorf.dn42"
role :db, "hyperion.chaosdorf.dn42", :primary => true
role :web, "hyperion.chaosdorf.dn42"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
