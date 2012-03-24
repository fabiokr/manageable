$:.push File.expand_path("../lib", __FILE__)

require "manageable/version"

Gem::Specification.new do |s|
  s.name        = "manageable"
  s.version     = Manageable::VERSION
  s.authors     = ["Fabio Kreusch"]
  s.email       = ["fabiokr@gmail.com"]
  s.homepage    = "https://github.com/fabiokr/manageable"
  s.summary     = "An administration engine"
  s.description = "An administration engine"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc", "CHANGELOG.rdoc"]
  s.test_files = Dir['spec/**/*']

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "sass-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 2.5"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl_rails", "~> 1.7.0" # Ruby 1.8 compatible
  s.add_development_dependency "shoulda-matchers"
end
