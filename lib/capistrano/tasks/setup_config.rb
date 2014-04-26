namespace :deploy do
  task :shared_path_testing do
      run_locally do
        puts "#{shared_path}"
      end
  end
  task :setup_config do
    on roles(:app) do
      # make the config dir
      execute :mkdir, "-p #{shared_path}/config"
      full_app_name = fetch(:full_app_name)

      # config files to be uploaded to shared/config, see the
      # definition of smart_template for details of operation.
      # Essentially looks for #{filename}.erb in deploy/#{full_app_name}/
      # and if it isn't there, falls back to deploy/#{shared}. Generally
      # everything should be in deploy/shared with params which differ
      # set in the stage files
      config_files = fetch(:config_files)
      config_files.each do |file|
        smart_template file
      end

      # which of the above files should be marked as executable
      executable_files = fetch(:executable_config_files)
      executable_files.each do |file|
        execute :chmod, "+x #{shared_path}/config/#{file}"
      end

      # symlink stuff which should be... symlinked
      symlinks = fetch(:symlinks)

      symlinks.each do |symlink|
        run_locally do
          puts "#{shared_path}"
          puts "#{symlink.to_s}"
        end
        sudo "ln -nfs #{shared_path}/config/#{symlink[:source]} #{sub_strings(symlink[:link])}"
      end
    end
  end
end
