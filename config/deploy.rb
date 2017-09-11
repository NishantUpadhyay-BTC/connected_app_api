lock '3.9.1'

set :application, 'cypher'

set :repo_url, 'git@github.com:NishantUpadhyay-BTC/connected_app_api.git'
set :deploy_to, '/home/deploy/cypher'
set :stage, :production
set :user, 'deploy'
set :pty, true
set :use_sudo, false
set :deploy_via, :remote_cache

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :rvm_path, '/home/deploy/.rvm'
set :rvm_type, :user
set :branch, 'aws_deployment.master' #set/ :branch,`git rev-parse --abbrev-ref HEAD`.chomp
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
