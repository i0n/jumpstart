

# Change Production environment config for use with remote server
FileUtils.append_to_end_of_file('  socket: /var/run/mysqld/mysqld.sock', "#{@install_path}/#{@project_name}/config/database.yml", true)

################################################################### REMOTE DEPLOYMENT ##############################################################

# Ask about deploying to remote server
# if yes?("Do you want to push this project to the remote server #{remote_server}?")
#   puts "Deploying to: #{remote_server}"
#   run "ssh #{remote_server} sudo git clone git://github.com/i0n/dotfiles.git /usr/local/bin/dotfiles" 
#   run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/make_git_repo /usr/local/bin/make_git_repo"
#   run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/nginx_auto_config /usr/local/bin/nginx_auto_config"
#   run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/nginx_auto_config.rb /usr/local/bin/nginx_auto_config.rb"
#   run "ssh #{remote_server} sudo cp /usr/local/bin/dotfiles/templates/rails/config/nginx.remote.conf /usr/local/bin/nginx.remote.conf"
#   run "ssh #{remote_server} sudo rm -rf /usr/local/bin/dotfiles"
#   run "ssh #{remote_server} 'make_git_repo #{app_name}'"
#   run "git remote add origin ssh://#{remote_server}/~/git/#{app_name}.git"
#   run "git push origin master"
#   run "cap deploy:setup"
#   run "cap deploy:create_mysql_db"
#   run "cap deploy:check"
#   run "cap deploy:nginx"
#   run "cap deploy:migrations"
# end
