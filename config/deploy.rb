set :application, 'testapp'
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_user, 'jeet'

# setup repo details
set :scm, :git
set :repo_url, 'git@bitbucket.org:ikilledthecat/testapp.git'


server '23.236.50.91', user: 'jeet', roles: %w{web app db}, primary: true
set :pty, true
set :user, "jeet"
set :deploy_via, :copy

# setup rvm.
# # deploy.rb or stage file (staging.rb, production.rb or else)
set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, '2.1.1@xlottapp'      # Defaults to: 'default'
set :rvm_custom_path, '~/.rvm'  # only needed if not detected
#
#set :rbenv_type, :system
#set :rbenv_ruby, '2.1.1'
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# how many old releases do we want to keep
set :keep_releases, 5

# files we want symlinking to specific entries in shared.
#set :linked_files, %w{config/database.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
#set :tests, []

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.yml
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/conf.d/#{fetch(:full_app_name)}.conf"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
  }#,
  #{
    #source: "log_rotation",
   #link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
  #},
  #{
    #source: "monit",
    #link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
  #}
])


# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  #before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  before "deploy", "deploy:check_revision"

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations
  # we've added
  #after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
end

