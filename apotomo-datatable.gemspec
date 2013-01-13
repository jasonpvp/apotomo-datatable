$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "apotomo-datatable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "apotomo-datatable"
  s.version     = ApotomoDatatable::VERSION
  s.authors     = ["Jason Van Pelt"]
  s.email       = ["jasonpvp@gmail.com"]
  s.homepage    = "https://github.com/jasonpvp/apotomo-datatable"
  s.summary     = "A jQuery Datatable widget built on Apotomo"
  s.description = "#{s.summary}. Render a jQuery datatable for a model/controller using as little as a couple lines of code."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
#  s.files = `git ls-files`.split("\n")
  s.test_files = Dir["spec/*/*"]

  s.add_dependency "rails", ">= 3.2.0"
  s.add_dependency 'apotomo', '~>1.2.2'
  s.add_dependency 'haml', '~>3.1.0'
#  s.add_dependency 'cells'

#  s.add_development_dependency 'apotomo', '~>1.2.2'
  s.add_development_dependency 'rspec-apotomo'
  s.add_development_dependency 'haml', '~>3.1.0'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-instafail'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'shoulda'
#  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara','>=2.0.1'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'launchy'
#  s.add_development_dependency 'spork'
#  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'actionpack'
#  s.add_development_dependency 'rails'

end
