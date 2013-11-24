set :application, 'mete'
set :repo_url, 'https://github.com/chaosdorf/mete'
set :deploy_to, '/srv/mete'

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/database.yml db/production.sqlite3}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      #within release_path do
      #  execute :rake, 'cache:clear'
      #end
    end
  end

  after :finishing, 'deploy:cleanup'

  task :create_favicons do
    options = {
      :root_dir => release_path,
      :input_dir => File.join("app", "assets", "images"),
      :output_dir => "public",
      :base_image => "mete-logo.svg"
    }
    FaviconMaker::Generator.create_versions(options) do |filepath|
      puts "Created favicon: #{filepath}"
    end
  end

  after "deploy:update_code", "deploy:create_versions"

end
