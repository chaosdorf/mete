set :stage, :development
set :rails_env, 'development'

role :app, %w{ubuntu@10.0.3.39}
role :web, %w{ubuntu@10.0.3.39}
