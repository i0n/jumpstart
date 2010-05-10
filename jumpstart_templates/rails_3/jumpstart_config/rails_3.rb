################################################################### SET INSTALL VARIABLES & DEPENDENCIES #################################

run "haml --rails ."

# create databases
rake("db:create:all")

# Change Production environment config for use with remote server
append_to_end_of_file('config/database.yml', '  socket: /var/run/mysqld/mysqld.sock', true)

# config for local OSX Nginx environment
nginx_auto_config("#{rails_templates_path}/rails/config/nginx.local.conf", '/usr/local/nginx/conf/nginx.conf', "#{app_name}")

# Appending URI to /etc/hosts to complete local OSX Nginx config
run "sudo chmod 777 /etc/hosts"
run "echo '\n127.0.0.1 #{app_name}.local'>>/etc/hosts"

################################################################### CAPISTRANO CONFIGURATION #############################################################

# Set application up for deployment with Capistrano
capify!

# Read Capistrano template and replace remote_server and app_name variables with the values entered during app creation
cap_txt = IO.read("#{rails_templates_path}/rails/config/deploy.rb")
cap_txt.gsub!(/\#\{remote_server\}/, "#{remote_server}")
cap_txt.gsub!(/\#\{app_name\}/, "#{app_name}")
file 'config/deploy.rb' do
  cap_txt
end

################################################################### GIT CONFIGURATION #############################################################

# Initialise Git repository
git :init

# Add all changes to the Git repository and then commit those changes.
git :add => "."
git :commit => "-v -a -m 'Initial commit'"

################################################################### REMOTE DEPLOYMENT ##############################################################

# Ask about deploying to remote server
if yes?("Do you want to push this project to the remote server #{remote_server}?")
  puts "Deploying to: #{remote_server}"
  run "ssh #{remote_server} sudo git clone git://github.com/i0n/dotfiles.git /usr/local/bin/dotfiles" 
  run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/make_git_repo /usr/local/bin/make_git_repo"
  run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/nginx_auto_config /usr/local/bin/nginx_auto_config"
  run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/nginx_auto_config.rb /usr/local/bin/nginx_auto_config.rb"
  run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/templates/rails/config/nginx.remote.conf /usr/local/bin/nginx.remote.conf"
  run "ssh #{remote_server} sudo rm -rf /usr/local/bin/dotfiles"
  run "ssh #{remote_server} 'make_git_repo #{app_name}'"
  run "git remote add origin ssh://#{remote_server}/~/git/#{app_name}.git"
  run "git push origin master"
  run "cap deploy:setup"
  run "cap deploy:create_mysql_db"
  run "cap deploy:check"
  run "cap deploy:nginx"
  run "cap deploy:migrations"
end
