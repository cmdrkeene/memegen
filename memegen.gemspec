# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "meme_generator"

Gem::Specification.new do |s|
  s.name        = "memegen"
  s.version     = MemeGenerator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brandon Keene"]
  s.email       = ["bkeene@gmail.com"]
  s.homepage    = "http://github.com/cmdrkeene/memegen"
  s.summary     = "Two-caption meme generator CLI"
  s.description = "Locally generate two-caption 'Advice Dog'-style meme images"
 
  s.required_rubygems_version = ">= 1.3.6"
  
  s.add_dependency("rmagick")
  s.add_dependency("tinder")
 
  s.files        = Dir.glob("{bin,lib,generators,fonts}/**/*") + %w(LICENSE README.md)
  s.executables  = ['memegen']
  s.require_path = 'lib'
end