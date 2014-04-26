namespace :deploy do
  desc "compiles assets locally then rsyncs"
  task :compile_assets_locally do
    run_locally do
      execute "RAILS_ENV=#{fetch(:rails_env)} bundle exec rake assets:precompile"
    end
    on roles(:app) do |role|
      run_locally do
        execute "rsync -avz -e 'ssh -i #{fetch(:ssh_options)[:keys].first}' ./public/assets/ #{role.user}@#{role.hostname}:#{release_path}/public/assets/;"
      end
    end
    run_locally do
      execute "rm -rf ./public/assets"
    end
  end
end
