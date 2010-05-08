module FileUtils
  class << self
  
    # For inserting a line after a specific line in a file. Note that this method will match only the first line it finds.
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

    # For appending text provided as a sring or a target file (source) to the end of another file (target_file). Takes an optional true/false as a third argument to remove the last line of the target file.
    def append_to_end_of_file(source, target_file, remove_last_line=false)
      t_file = IO.readlines(target_file)
      t_file.pop if remove_last_line == true
      new_file = []
      new_file << t_file << check_source_type(source)
      File.open(target_file, "w") do |x|
        x.puts new_file
      end
    end
    
    # For inserting text provided as a string or a target file (source) to a specific line number (line_number) of another file (target_file) 
    def insert_text_at_line_number(source, target_file, line_number)
      line_number -= 1
      file = IO.readlines(target_file)
      file.insert((line_number), check_source_type(source))
      File.open(target_file, "w") do |x|
        x.puts file
      end      
    end
  
    # For setting up app in Nginx 
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
    
    private
    
    def check_source_type(source)
      if File.file?(source)
        source_file = IO.readlines(source)
      else
        source_file = source
      end
      source_file
    end
      
  end    
end
