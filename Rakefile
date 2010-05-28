$:.unshift File.expand_path("../lib", __FILE__)

require 'rubygems'
require 'rake'
require 'jumpstart'

# Get JumpStart version
jumpstart_version = JumpStart::VERSION.match(/^(\d+)\.(\d+)\.(\d+)/)

# Runs all tests
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

namespace :deploy do
    
  
end

namespace :version do
  
  namespace :bump do
    
    desc "Bumps major version number by 1"
    task :major do
      JumpStart::Setup.bump_version_major
    end

    desc "Bumps minor version number by 1"
    task :minor do
      JumpStart::Setup.bump_version_minor
    end

    desc "Bumps patch version number by 1"
    task :patch do
      JumpStart::Setup.bump_version_patch
    end

  end
  
end