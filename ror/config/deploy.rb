# -*- encoding : utf-8 -*-
set :application, "dosa"
set :user, "tbs"
set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
server "localhost", :web, :app, :db, primary: true

set :scm, :git
set :repository,  "git@github.com:njunewfish/soya.git"
set :branch, "master"
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{user}/#{application}"

# Fix log/ and pids/ permisssions
#after "deploy:setup", "deploy:fix_setup_permissions"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
set :keep_releases, 5

# in case your project like ours, include ror, spring and other subprojects, if not, change it to '.'
set :middle_path, "ror"

set :unicorn_path, "#{deploy_to}/current/#{middle_path}/config/unicorn.rb"
namespace :deploy do
  task :start, :roles => :app do
    run "cd #{deploy_to}/current/#{middle_path}; RAILS_ENV=production unicorn_rails -c #{unicorn_path} -D"
  end

  task :stop, :roles => :app do
    run "kill -QUIT `cat #{deploy_to}/current/#{middle_path}/tmp/pids/unicorn.pid`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "kill -USR2 `cat #{deploy_to}/current/#{middle_path}/tmp/pids/unicorn.pid`"
  end
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
