namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app), in: :sequence do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
end
