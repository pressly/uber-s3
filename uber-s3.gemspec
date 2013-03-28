# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'uber-s3/version'

Gem::Specification.new do |s|
  s.name        = 'crashlytics-uber-s3'
  s.version     = UberS3::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'A simple & very fast S3 client supporting sync / async HTTP adapters'
  s.description = s.summary

  s.authors     = ['Peter Kieltyka']
  s.email       = ['peter@nulayer.com']
  s.homepage    = 'http://github.com/nulayer/uber-s3'
  
  s.required_rubygems_version = ">= 1.3.6"
  
  s.files        = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'

  s.add_dependency('mime-types', ['~> 1.17'])

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', ['~> 2.7.0'])
end
