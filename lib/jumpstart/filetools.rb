module JumpStart::FileTools

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

  def remove_files(root_dir, file_array)
    file_array.map! {|x| root_dir + x }
    begin
      Dir.chdir(root_dir)
      file_array.each do |x|
        if File.exists?(x)
          if File.writable?(x)
            puts
            puts "Removing the unwanted file: #{x}"
            File.delete(x)
          else
            puts
            puts "You do not have the correct privileges to delete #{x}. It has NOT been deleted."
          end
        else
          puts
          puts "The file #{x} could not be deleted as it could not be found."
        end
      end
    rescue
      puts
      puts "Uh-oh, we've hit a snag with the remove_files method."
      puts "The directory #{root_dir} could not be found, or you do not have the correct privileges to access it."
    end
  end
  
  # For removing lines in a file that (A) match a specific pattern, and/or (B) or are specified by line number.
  # Both types of removal are passed to the method via the arguments hash.
  # e.g. remove lines macthing a pattern, do FileUtils.remove_lines(target_file, :pattern => "Hello!")
  # e.g. remove lines by line number, do FileUtils.remove_lines(target_file, :lines => [1,2,3,4,99])
  # You can use both methods of removal at once.
  # In Ruby 1.9+ you can also pass a hash like this: FileUtils.remove_lines(target_file, pattern: "hello!", lines: [1,2,3,4,99])
  def remove_lines(target_file, args)
    new_file = []
    original_lines = IO.readlines(target_file)
    case
    when args[:line] != nil && args[:lines] == nil then
      args[:line] -= 1
      original_lines.slice!(args[:line])
    when args[:lines] != nil && args[:line] == nil  then
      args[:lines].map! {|x| x -= 1}
      args[:lines].each do |y|
        original_lines[y] = "JumpStart::FileTools => LINE MARKED FOR DELETION"
      end
      original_lines.delete("JumpStart::FileTools => LINE MARKED FOR DELETION")
    when args[:lines] != nil && args[:line] != nil then
      puts "You have specified a :line argument at the same time as a :lines argument, only one can be used at a time."
    when args[:pattern] != nil then
      original_lines.each do |line|
        if line =~ /#{args[:pattern]}/
          original_lines.slice!(original_lines.find_index(line))
        end
      end
    end
    new_file += original_lines
    File.open(target_file, "w") do |x|
      x.puts new_file
    end
  end

  # For setting up app in Nginx 
  def config_nginx(source_file, target_file, app_name)
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
    else
      puts
      puts "******************************************************************************************************************************************"
      puts
      puts "Configuring NginX at: #{target_file}"
      puts
      if File.writable?(target_file)
        nginx_config = IO.readlines(target_file)
        while nginx_config.last !~ /^\}[\n]*/
          nginx_config.pop
        end
        @nginx_last_line = nginx_config.pop
        source_config = IO.read(source_file)
        nginx_config.push source_config
        nginx_config.push @nginx_last_line
        nginx_config.each {|line| line.gsub!(/\#\{app_name\}/, "#{app_name}")}
        File.open(target_file, "w") do |file|
          file.puts nginx_config
        end
        puts "Success! NginX config for #{app_name} has been added to #{target_file}"
        puts
        puts "******************************************************************************************************************************************"
        puts
      else
        puts "It doesn't look like you have write access for #{target_file}. Would you like to use sudo to change them?"
        puts "Type yes (y) or no (n)"
        input = gets.chomp
        if input == "yes" || input == "y"
          puts "Setting permissions for #{target_file}"
          system "sudo chmod 755 #{target_file}"
          config_nginx(source_file, target_file, app_name)
        else
          puts "Skipping automatic NginX config."
        end
      end
    end
  end

  # For configuring /etc/hosts. Necessary under OS X for NginX configuration to work.
  def config_etc_hosts(app_name)
    puts
    puts "******************************************************************************************************************************************"
    puts
    puts "Configuring /etc/hosts"
    puts
    begin
      if File.writable?("/etc/hosts")
        etc_hosts = IO.readlines("/etc/hosts")
        etc_hosts << "\n127.0.0.1 #{app_name}.local"
        File.open('/etc/hosts', "w") do |file|
          file.puts etc_hosts
        end
        puts "Success! #{app_name} has been added to /etc/hosts"
        puts          
      else
        puts "It doesn't look like you have write access for /etc/hosts. Would you like to use sudo to change them?"
        puts "Type yes (y) or no (n)"
        puts
        input = gets.chomp
        if input == "yes" || input == "y"
          puts "Setting permissions for /etc/hosts"
          puts
          system "sudo chmod 755 /etc/hosts"
          config_etc_hosts(app_name)
        else
          puts "Skipping automatic /etc/hosts config."
        end
      end
    rescue
      puts "There was a problem accessing the file /etc/hosts, you may need to adjust the privileges."
      puts
    end
    puts "******************************************************************************************************************************************"
    puts
  end

  # TODO Think about wrapping this functionality up in a generic method with pairs of values for variable replacement
  def config_capistrano(target_file, app_name, remote_server)
    cap_txt = IO.read(target_file)
    cap_txt.gsub!(/\#\{remote_server\}/, "#{remote_server}")
    cap_txt.gsub!(/\#\{app_name\}/, "#{app_name}")
    File.open(target_file, "w") do |file|
      file.puts cap_txt
    end
  end

  def make_bare_git_repo(target_dir, app_name)
    Dir.chdir target_dir
    Dir.mkdir "#{app_name}.git"
    Dir.chdir "#{target_dir}/#{app_name}.git"
    system "git init --bare"
    puts "SUCCESS! git repo #{app_name}.git created."
  end

  def check_source_type(source)
    if File.file?(source)
      source_file = IO.readlines(source)
    else
      source_file = source
    end
    source_file
  end
    
end
