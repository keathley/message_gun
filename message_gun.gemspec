# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'message_gun/version'

Gem::Specification.new do |spec|
  spec.name          = "message_gun"
  spec.version       = MessageGun::VERSION
  spec.authors       = ["Chris Keathley"]
  spec.email         = ["spyc3r@gmail.com"]
  spec.summary       = %q{Send messages through twilio like a boss}
  spec.description   = %q{
                           Message-Gun is used to test systems that receive
                           text messages by sending lots of messages through
                           the twilio API.
                         }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'yaml'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
