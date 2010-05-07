module JumpStart
  class FileTools
    class << self
    
      # Method for inserting a line after a specific line in a file. Note that this method will match only the first line it finds.
      def append_after_line(target_file, target_line, new_line)
        file = IO.readlines(target_file)
        new_file = file.dup
        file.each do |line|
          if line.chomp == target_line.chomp && new_line != nil
            new_file.insert((file.find_index(line) + 1), new_line)
            new_line = nil
          end
        end
        File.open(target_file, "w") do |x|
          x.puts new_file
        end
      end

      # Method for appending text to the end of a file. Takes an optional true/false as a third argument to remove the last line of the file.
      def append_to_end_of_file(target_file, new_line, remove_last_line=false)
        file = IO.readlines(target_file)
        file.pop if remove_last_line == true
        file.push new_line
        File.open(target_file, "w") do |x|
          x.puts file
        end
      end
        
      # append_to_end_of_file('/Users/i0n/Sites/jumpstart/lib/jumpstart/test.txt', 'NEW LINE!')
    
      # Method for setting up app in Nginx 
      def nginx_auto_config(source_file, target_file, app_name)
        if source_file == nil || target_file == nil || app_name == nil
          puts
          puts "******************************************************************************************************************************************"
          puts
          puts "You need to specify three paramters to use this script:\n\n1: The Source File.\n2: The Target File.\n3: The App Name."
          puts
          puts "e.g. nginx_auto_config /Users/i0n/Sites/bin/templates/rails/config/nginx.local.conf /usr/local/nginx/conf/nginx.conf test_app"
          puts
          puts "******************************************************************************************************************************************"
          puts
          exit
        else
          puts
          puts "******************************************************************************************************************************************"
          puts
          puts "Setting permissions for: #{target_file}"
          puts
          system "sudo chmod 755 #{target_file}"
          nginx_config = IO.readlines(target_file)
          nginx_config.delete_if do |line|
            line == "\n" || line == ""
          end
          nginx_config.reverse_each do |line|      
            if line =~ /^\}[\n]*/
              @nginx_last_line = nginx_config.slice!(nginx_config.find_index(line))
              break
            end
          end
          source_config = IO.read(source_file)
          nginx_config.push source_config
          nginx_config.push @nginx_last_line
          nginx_config.each {|line| line.gsub!(/\#\{app_name\}/, "#{app_name}")}
          File.open(target_file, "w") do |file|
            file.puts nginx_config
          end
          puts "Success! Nginx config for #{app_name} has been added to #{target_file}"
          puts
          puts "******************************************************************************************************************************************"
          puts
        end
      end
    
      def make_bare_git_repo(target_dir, app_name)
        Dir.chdir target_dir
        Dir.mkdir "#{app_name}.git"
        Dir.chdir "#{target_dir}/#{app_name}.git"
        system "git init --bare"
        puts "SUCCESS! git repo #{app_name}.git created."
      end
        
    end    
  end
end
