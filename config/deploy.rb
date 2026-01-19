# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.0'

set :application, 'tessi'
set :repo_url, 'git@github.com:keithyoder/tessi.git'

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

# Keep only the last 3 releases
set :keep_releases, 3

# Linked directories and files
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle',
                     'public/system', 'public/uploads', 'storage'
# append :linked_files, 'config/database.yml', 'config/secrets.yml' # if needed

# Default environment variables
set :default_env, { 'JAVA_HOME' => '/usr/lib/jvm/java-11-openjdk-amd64' }

# rbenv configuration
set :rbenv_type, :user                       # rbenv installed in deploy user home
set :rbenv_ruby, '2.7.7'                    # match your Gemfile ruby
set :rbenv_path, '/home/deploy/.rbenv'      # explicit path to rbenv
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all                       # apply to all roles

# Passenger integration (if using nginx + passenger)
set :passenger_restart_with_touch, true      # restart Passenger by touching tmp/restart.txt

# Optional Airbrussh formatting
set :format, :airbrussh
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
