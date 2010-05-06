set :application, "#{app_name}"
set :domain, "#{remote_server}"
set :user, 'i0n'

set :repository,  "#{user}@#{domain}:/home/#{user}/git/#{application}.git"

role :app, domain                           # This may be the same as the `Web` server
role :web, domain                           # Your HTTP server, Apache/etc
role :db,  domain , :primary => true        # This is where Rails migrations will run

set :scm_verbose, true

set :scm, :git
set :scm_username, user
set :runner, user
set :use_sudo, false
set :branch, "master"
set :deploy_via, :checkout
set :git_shallow_clone, 1
set :deploy_to, "/home/#{user}/sites/#{application}"
default_run_options[:pty] = true

namespace :deploy do
  #task which causes Passenger to initiate a restart
  task  :restart do
    run "mkdir -p #{release_path}/tmp && touch #{release_path}/tmp/restart.txt"
  end
  
  task :install_gems do
    run "cd #{current_path}; rake gems:install"
  end
  
  namespace :db do
    
    desc "Create database for the production environment using the servers rake db:setup task.\n Loads the schema, and initializes with the seed data"
    task :setup do
      run "cd #{current_path}; rake db:setup RAILS_ENV=production"
    end 
        
    desc "Populates the production database using lib/tasks/populate which I will use as my own internal convention for this process"
    task :populate do
      run "cd #{current_path}; rake db:populate RAILS_ENV=production"
    end
    
  end
  
  desc "Task to set up the remote Nginx server for app deployment"
  task :nginx do
    run "#{sudo} nginx_auto_config /usr/local/bin/nginx.remote.conf /opt/nginx/conf/nginx.conf #{app_name}"
  end
  
  desc "Create bare remote git repo then add remote origin to local git repo and push to remote"
  task :git do
    run "cd /home/#{user}/git; mkdir #{application}.git; cd #{application}.git; git init --bare"
    `git remote add origin ssh://#{user}@#{domain}/~/git/#{application}.git`
    `git push origin master`
  end
  
end

after 'deploy:symlink', 'deploy:install_gems'

# Reminder of default actions for cap deploy:
# deploy:update_code
# deploy:symlink
# deploy:restart