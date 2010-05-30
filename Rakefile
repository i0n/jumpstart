$:.unshift File.expand_path("../lib", __FILE__)

require 'rubygems'
require 'rake'
require 'jumpstart'

# Runs all tests
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

namespace :deploy do
    
  desc "Commits changes to local git repo and then pushes to remote"
  task :git do
    git_actions
  end
    
  desc "Builds gemspec and deploys gem to RubyGems.org"
  task :gem do
    rubygems_actions
  end
  
end

namespace :bump do
  
  desc "Bumps major version number by 1"
  task :major do
    JumpStart.bump_version_major
    git_actions
    rubygems_actions
  end

  desc "Bumps minor version number by 1"
  task :minor do
    JumpStart.bump_version_minor
    git_actions
    rubygems_actions
  end

  desc "Bumps patch version number by 1"
  task :patch do
    JumpStart.bump_version_patch
    git_actions
    rubygems_actions
  end
  
end

task :version do
  puts "\nJumpStart Version: #{JumpStart::VERSION}"
end

task :existing_templates do
  puts "\n Existing JumpStart templates:"
  puts JumpStart.existing_templates
end

def git_actions
  Dir.chdir("#{JumpStart::ROOT_PATH}")
  system "git add ."
  system "git commit -v -a -m 'commit for version: #{JumpStart.version}'"
  system "git tag #{JumpStart.version}"
  system "git push"
  system "git push --tags"
end

def rubygems_actions
  Dir.chdir("#{JumpStart::ROOT_PATH}")
  system "gem build jumpstart.gemspec"
  system "gem push jumpstart-#{JumpStart.version}.gem"      
end
