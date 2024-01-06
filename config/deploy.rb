# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.18.0'

set :application, 'movie_review'
set :repo_url, 'https://github.com/palhimalaya/MovieReviewApp.git'

# rvm version in server. Change the rvm ruby if you are using a different rvm ruby version
set :rvm_ruby_version, 'ruby-3.2.2'
set :branch, 'docker'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/#{fetch(:application)}"

# Default value for :format is :airbrussh.
set :format, :pretty

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

set :linked_files, %w[config/application.yml .env config/database.yml config/master.key]

# Default value for linked_dirs is []
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle .bundle public/system public/uploads node_modules]

set :whenever_roles, [:app]
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

set :migration_role, :app

set :conditionally_migrate, true
# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# ================================================
# ============ From Custom Rake Tasks ============
# ================================================
# ===== See Inside: lib/capistrano/tasks =========
# ================================================

# upload configuration files
before 'deploy:starting', 'config_files:upload'

# set :initial, true
# before 'deploy:migrate', 'database:create' if fetch(:initial)

after 'deploy:publishing', 'application:reload'
