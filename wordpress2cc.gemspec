# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wordpress2cc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bracken Mosbacker"]
  gem.email         = ["bracken@instructure.com"]
  gem.description   = %q{Migrates Wordpress backups to IMS Common Cartridge package}
  gem.summary       = %q{Migrates Wordpress backups to IMS Common Cartridge package}
  gem.homepage      = "https://github.com/bracken/wordpress2cc"

  gem.add_runtime_dependency "rubyzip"
  gem.add_runtime_dependency "happymapper"
  gem.add_runtime_dependency "builder"
  gem.add_runtime_dependency "thor"
  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "rdiscount"
  gem.add_runtime_dependency "moodle2cc"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-minitest"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "wordpress2cc"
  gem.require_paths = ["lib"]
  gem.version       = Wordpress2CC::VERSION
end
