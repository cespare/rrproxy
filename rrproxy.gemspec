$:.unshift File.join(File.dirname(__FILE__), "lib")
require "rrproxy/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Caleb Spare"]
  gem.email         = ["cespare@gmail.com"]
  gem.description   = %q{rrproxy is a very simple routing reverse proxy written in Ruby.}
  gem.summary       = %q{A routing reverse proxy.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rrproxy"
  gem.version       = RRProxy::VERSION
  gem.require_paths = ["lib"]

  gem.add_dependency "goliath"
  gem.add_dependency "log4r"
  gem.add_dependency "em-http-request"
  gem.add_dependency "trollop"
  gem.add_dependency "dedent"
  gem.add_dependency "colorize"
end
