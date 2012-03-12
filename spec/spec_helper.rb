ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'capybara-webkit'
require 'database_cleaner'
require 'factory_girl'
require 'shoulda-matchers'
require 'manageable/spec/models/acts_as_article'

FactoryGirl.definition_file_paths = [File.join(Manageable::Engine.root, 'spec', 'factories')]
FactoryGirl.find_definitions

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.include Capybara::DSL, :example_group => { :file_path => /\bspec\/integration\// }

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end