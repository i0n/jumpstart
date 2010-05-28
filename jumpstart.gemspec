# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jumpstart'
 
Gem::Specification.new do |s|
  s.name        = "jumpstart"
  s.version     = JumpStart.version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Alexander Wood (i0n)"]
  s.email       = ["ianalexanderwood@gmail.com"]
  s.homepage    = "http://github.com/i0n/jumpstart"
  s.summary     = "Quickly start Ruby projects just the way you want them using a single YAML file and reusable templates."
  s.description = "JumpStart is a script runner and template parser written in Ruby with Ruby projects in mind.\nThat said it should function equally well for any project in any language where many actions need to be performed to setup a new project."
  s.required_rubygems_version = ">= 1.3.6" 
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
  s.files        = Dir.glob("{bin,config,jumpstart_templates,lib,source_templates,test}/**/*") + %w(LICENSE Rakefile README.md)
  s.files.each do |x|
    if x.match(/jumpstart_templates\/i0n/)
      s.files.delete(x)
    end
  end
  puts s.files
  s.executables  = ['jumpstart']
  s.require_path = 'lib'
end