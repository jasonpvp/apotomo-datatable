# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
#require 'rubygems'
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rails'
#require 'action_pack'
#require 'action_controller'
require 'rspec-apotomo'
require 'shoulda-matchers'
require 'rspec/rails'
require 'rspec/autorun'
#require 'bundler/setup'
require 'apotomo'
require 'apotomo-datatable'

require 'database_cleaner'
require 'factories.rb'

if $run_in_browser
  puts 'loading capybara'
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/rspec'
  require 'selenium-webdriver'
  require 'capybara/rails'
end

if ENV["TRACE"] then
  #enable full trace
  set_trace_func proc {
    |event, file, line, id, binding, classname| 
    if event == "call" or event == "return" 
      printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
    end
  }
end

#Capybara.register_driver :selenium_chrome do |app|   
#  Capybara::Selenium::Driver.new(app, :browser => :chrome)
#end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods
#  config.include Capybara::DSL
#  config.include Capybara::RSpecMatchers

  config.before(:suite) do
    DatabaseCleaner.strategy=:transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end


