#JumpStart

Jumpstart is a gem for quickly creating projects.
It does this by running options from a YAML file that you can create, or you can let the gem do it for you.
It's dead easy to do.

## Features
With jumpstart you can:

* Run many terminal commands in a specific order
* Create new projects of any type quickly from templates
* Create files from three different kinds of templates:
  * **Whole templates**. A like for like copy from the template to the new project.
  * **Append templates**. The template is appended to a file generated by a terminal command (e.g. rails)
  * **Line templates**. The template is inserted into a file generated by a terminal command at a specific line number.
* Replace strings in the newly generated project with specified tags (like the project name)
* Automatically configure local Nginx and hosts entries for a new project. (I'm using OS X so this is tailored for the Mac.)
* Remove unwanted files that may have been created by a terminal command (e.g. rails)

# Installation
`gem install jumpstart` should do it.
- - - - -
Or you can clone this git repo:               `git://github.com/i0n/jumpstart.git`  
Build jumpstart from the git repo's gemspec:  `gem build jumpstart.gemspec`  
Install the newly created gem:                `gem install jumpstart-WHATEVER_THE_CURRENT_VERSION_IS.gem`  

**NOTE!** If you install jumpstart using `sudo` then you will probably need to run jumpstart with it as well to grant writes to the YAML files in the gem.

## Getting Started
There are a couple of ways to use jumpstart.

If you have already created a template, you can create a new project with a single command from the terminal.  
e.g. **`jumpstart my_new_project_name`**  

If you haven't created any templates yet, or you want to change one of the configuration options (which I'll get to), just call **`jumpstart`** without any arguments. This will launch the jumpstart menu.

## Example YAML files.
1.  
<code>
  ---
  :install_path: /Users/i0n/Sites
  :install_command: rails 
  :install_command_args: -d mysql -J -T
  :run_after_install_command:
    - rails g controller home
  :remove_files:
    - /app/views/layouts/application.html.erb
    - /public/index.html
    - /public/favicon.ico
    - /public/images/rails.png
  :run_after_jumpstart:
    - rake db:create
    - capify .
    - git init
    - git add .
    - git commit -q -v -a -m "Initial commit"
  :replace_strings:
    - :target_path: /config/deploy.rb
      :symbols:
        :project_name: name_of_my_app
        :remote_server: thoughtplant
    - :target_path: /config/environments/development.rb
      :symbols:
        :project_name: name_of_my_app
    - :target_path: /config/environments/test.rb
      :symbols:
        :project_name: name_of_my_app
    - :target_path: /config/environments/production.rb
      :symbols:
        :project_name: name_of_my_app
  :local_nginx_conf: /usr/local/nginx/conf/nginx.conf
</code>
###Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

**Copyright**

Copyright (c) 2010 i0n. See LICENSE for details.
