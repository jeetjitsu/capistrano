# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

#role :app, %w{deploy@example.com}
#role :web, %w{deploy@example.com}
#role :db,  %w{deploy@example.com}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.
set :stage, :production
set :branch, "master"


# This is used in the Nginx VirtualHost to specify which domains
# the app should appear on. If you don't yet have DNS setup, you'll
# need to create entries in your local Hosts file for testing.
set :server_name, "localhost"
# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths

server '23.236.50.91', user: 'jeet', roles: %w{web app db}, primary: true

set :ssh_options, {
  keys: %w(/home/jeet/.ssh/google_compute_engine),
  forward_agent: true#,
  #auth_methods: %w(Xlott_123)
}

set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :rails_env, "production"
set :unicorn_worker_count, 5
set :enable_ssl, false
# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
  #set :ssh_options, {
    #keys: %w(/home/jeet/.ssh/google_compute_engine),
    #forward_agent: true#,
    ##auth_methods: %w(Xlott_123)
  #}
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
