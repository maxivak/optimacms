$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "optimacms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "optimacms"
  s.version     = Optimacms::VERSION
  s.authors     = ["Max Ivak"]
  s.email       = ["maxivak@gmail.com"]
  s.homepage    = "http://maxivak.com"
  s.summary     = "CMS"
  s.description = "CMS on Ruby on Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0"

  s.add_development_dependency "mysql2", '~> 0'

  s.add_dependency "devise", "~> 4.2"

  #s.add_dependency "haml", "~> 4.0.6"
  s.add_dependency "haml-rails", "~> 0.9.0"

  s.add_dependency "jquery-rails" #, "~> 4.0.3"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "coffee-rails" #, "~>4.1.0"
  s.add_dependency "uglifier"

  s.add_dependency "font-awesome-rails" #, '~> 4.3'

  s.add_dependency "sass-rails", '>= 5.0.4'

  #s.add_dependency 'bootstrap-sass' #, '~> 3.3.4'
  s.add_dependency 'bootstrap', '~> 4.0.0.alpha6'

  s.add_dependency 'simple_form'
  s.add_dependency 'paperclip'
  s.add_dependency 'ancestry'

  s.add_dependency 'globalize'
  s.add_dependency 'globalize-accessors'



  s.add_dependency 'simple_search_filter' #, '~>0.0.31'
  s.add_dependency 'bootstrap_autocomplete_input'


  # test
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'

  s.test_files = Dir["spec/**/*"]

end
