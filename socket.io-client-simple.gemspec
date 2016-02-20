# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socket.io-client-simple/version'

Gem::Specification.new do |spec|
  spec.name          = "socket.io-client-simple"
  spec.version       = SocketIO::Client::Simple::VERSION
  spec.authors       = ["Sho Hashimoto"]
  spec.email         = ["hashimoto@shokai.org"]
  spec.description   = "A simple ruby client for Node.js's Socket.IO v1.1.x, Supports only WebSocket."
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/shokai/ruby-socket.io-client-simple"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_dependency "json"
  spec.add_dependency "websocket-client-simple", '~> 0.3.0'
  spec.add_dependency "httparty"
  spec.add_dependency "event_emitter"
end
