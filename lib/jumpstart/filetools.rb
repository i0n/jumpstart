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
    if line_number > 0
      line_number -= 1
      file = IO.readlines(target_file)
      file.insert((line_number), check_source_type(source))
      File.open(target_file, "w") do |x|
        x.puts file
      end
    else
      raise ArgumentError, "Line number must be 1 or higher.".red
    end
  end

  # Deletes all files and folders in a directory. Leaves target_dir intact.
  def delete_dir_contents(target_dir)
    files_and_dirs = Find.find(target_dir)
    files_and_dirs.each do |x|
      if File.file?(x)
        FileUtils.rm(x)
      elsif File.directory?(x) && x != target_dir && File.directory?(x)
        FileUtils.remove_dir(x)
      end
    end
  end

  def remove_files(file_array)
    file_array.each do |x|
      begin
        if File.exists?(x)
          if File.writable?(x)
            puts
            puts "Removing the unwanted file: #{x.green}"
            File.delete(x)
          else
            puts
            puts "You do not have the correct privileges to delete #{x.red}. It has NOT been deleted."
          end
        else
          puts
          puts "The file #{x.red} could not be deleted as it could not be found."
        end          
      rescue
        puts
        puts "Uh-oh, we've hit a snag with the remove_files method.".red
        puts "The file #{x.red} could not be deleted, do you have the correct privileges to access it?"
      end
    end
  end
  
  # For removing lines in a file that (A) match a specific pattern, and/or (B) or are specified by line number.
  # Both types of removal are passed to the method via the arguments hash.
  # e.g. remove lines macthing a pattern, do FileUtils.remove_lines(target_file, :pattern => "Hello!")
  # e.g. remove lines by line number, do FileUtils.remove_lines(target_file, :lines => [1,2,3,4,99])
  # e.g. You can also remove a single line by line number by passing :line. (FileUtils.remove_lines(target_file, :line => 2))
  # You can remove lines using :lines/:line and :pattern at the same time.
  # In Ruby 1.9+ you can also pass a hash like this: FileUtils.remove_lines(target_file, pattern: "hello!", lines: [1,2,3,4,99])
  def remove_lines(target_file, args)
    new_file = []
    original_lines = IO.readlines(target_file)
    if args[:line] != nil && args[:lines] == nil
      args[:line] -= 1
      original_lines.slice!(args[:line])
    elsif args[:lines] != nil && args[:line] == nil
      args[:lines].map! {|x| x -= 1}
      args[:lines].each do |y|
        original_lines[y] = nil
      end
    elsif args[:lines] != nil && args[:line] != nil
      puts
      puts "You have used an incorrect syntax for the FileUtils.remove_lines method.".red
      puts "You have specified a" + " :line".red_bold + " argument at the same time as a " + ":lines".red_bold + " argument, only one can be used at a time."
      raise ArgumentError
    end
    if args[:pattern] != nil then
      original_lines.each do |line|
        if line =~ /#{args[:pattern]}/
          original_lines[original_lines.find_index(line)] = nil
        end
      end
    end
    original_lines.compact!
    new_file += original_lines
    File.open(target_file, "w") do |x|
      x.puts new_file
    end
  end
  
  # This method generates string replacements via a hash passed to the method, this enables versatile string replacement.
  # To replace values in the target file, simply add the name of the key for that replacement in CAPS.
  # e.g. You might call the method with something like: FileUtils.replace_strings(target_file, :name => "Ian", :country => "England")
  # ... and in the template it would look like this:
  # Hello there NAME from COUNTRY
  def replace_strings(target_file, args)
    txt = IO.read(target_file)
    args.each do |x, y|
      txt.gsub!(/#{x.upcase}/, y)
    end
    File.open(target_file, "w") do |file|
      file.puts txt
    end
  end
  
  # For setting up app in Nginx 
  def config_nginx(source_file, target_file, app_name)
    if source_file == nil || target_file == nil || app_name == nil
      puts
      puts "******************************************************************************************************************************************"
      puts
      puts "You need to specify three paramters to use this script:\n\n1: The Source File.\n2: The Target File.\n3: The App Name.".yellow
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
        puts "Success! NginX config for #{app_name.green} has been added to #{target_file.green}"
        puts
        puts "******************************************************************************************************************************************"
        puts
      else
        puts "It doesn't look like you have write access for #{target_file}. Would you like to use sudo to change them?".yellow
        puts "Type yes (" + "y".green + ") or no (" + "n".red + ")"
        input = gets.chomp
        if input == "yes" || input == "y"
          puts "Setting permissions for #{target_file.green}"
          system "sudo chmod 755 #{target_file}"
          config_nginx(source_file, target_file, app_name)
        else
          puts "Skipping automatic NginX config."
        end
      end
    end
  end

  # For configuring /etc/hosts. Necessary under OS X for NginX configuration to work.
  def config_hosts(target_file, app_name)
    puts
    puts "******************************************************************************************************************************************"
    puts
    puts "Configuring /etc/hosts"
    puts
    begin
      if File.writable?(target_file)
        etc_hosts = IO.readlines(target_file)
        etc_hosts << "127.0.0.1 #{app_name}.local"
        etc_hosts.compact!
        File.open(target_file, "w") do |file|
          file.puts etc_hosts
        end
        puts "Success! #{app_name.green} has been added to #{target_file.green}"
        puts          
      else
        puts "It doesn't look like you have write access for #{target_file}. Would you like to use sudo to change them?".yellow
        puts "Type yes (" + "y".yellow + ") or no (" + "n".yellow + ")"
        puts
        input = gets.chomp
        if input == "yes" || input == "y"
          puts "Setting permissions for #{target_file.green}"
          puts
          system "sudo chmod 755 #{target_file}"
          config_etc_hosts(app_name)
        else
          puts "Skipping automatic #{target_file} config."
        end
      end
    rescue
      puts "There was a problem accessing the file #{target_file.red}, you may need to adjust the privileges."
      puts
    end
    puts "******************************************************************************************************************************************"
    puts
  end
  
  def check_source_type(source)
    if File.file?(source)
      source_file = IO.readlines(source)
    else
      source_file = source
    end
    source_file
  end
  
  # Method for joining paths together. Paths can be supplied as a mixture of strings and arrays.
  # If too many or not enough forward slashes are provided at the start/end of the paths, this will be corrected.
  # Accidentally passing nil values mixed with strings/arrays will be corrected.
  # Whitespace and line breaks mixed with the path will be corrected.
  # If too many files (paths containing one or more '.' fullstops) are specified in the supplied paths, the first one that creates a path will be returned.
  # If the path is an absolute path (starting with /) this will be preserved.
  def join_paths(*args)
    paths = args.dup
    paths.flatten!
    full_path = []
    file_detected = false
    absolute_path = true if paths[0].to_s.start_with?('/')
    paths.each do |path|
      unless path.nil?
        path.strip!
        path.slice!(0) while path.start_with?('/')
        path.chop! while path.end_with?('/')
        if file_detected == false
          file_detected = true if path =~ /\w*\.\w*/
          full_path << path
        end
      end
    end
    full_path[0].insert(0, '/') if absolute_path
    full_path.join('/')
  end
  
  def sort_contained_files_and_dirs(path)
    dirs, files = [], []
    if path != nil && File.directory?(path)
      Find.find(path) do |x|
        case
        when File.directory?(x)
          x.sub!(path, '')
          dirs << x unless x.length == 0
        when File.file?(x)
          x.sub!(path, '')
          files << x unless x.length == 0
        end
      end
    end
    {:files => files, :dirs => dirs}
  end
      
end
