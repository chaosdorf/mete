require 'bundler/capistrano'

set :application, "mete"
set :deploy_to, "/srv/mete"
set :repository,  "https://github.com/chaosdorf/mete"
set :scm, :git
set :use_sudo, false
set :user, "mete"

role :app, "meteserver.chaosdorf.dn42"
role :db, "meteserver.chaosdorf.dn42", :primary => true
role :web, "meteserver.chaosdorf.dn42"

after 'deploy:update', 'deploy:symlink_shared_paths', 'deploy:migrate', 'deploy:assets:precompile'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared_paths do
    run "mkdir -p #{shared_path}/db"
    run "mkdir -p #{shared_path}/public/assets"
    run "mkdir -p #{shared_path}/files"
    run "mkdir -p #{shared_path}/log"
    run "ln -fns #{shared_path}/db/production.sqlite3 #{release_path}/db/"
    run "ln -fns #{shared_path}/public/assets #{release_path}/public/"
    run "ln -fns #{shared_path}/files #{release_path}"
    run "ln -fns #{shared_path}/log #{release_path}"
  end
end
