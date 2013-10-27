set :stage, :production
set :rails_env, 'production'

role :app, %w{mete@meteserver.chaosdorf.dn42}
role :web, %w{mete@meteserver.chaosdorf.dn42}

