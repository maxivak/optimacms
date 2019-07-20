$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "optimacms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "optimacms"
  s.version     = Optimacms::VERSION
  s.authors     = ["Max Ivak"]
  s.email       = ["maxivak@gmail.com"]
  s.homepage    = "https://github.com/maxivak/optimacms"
  s.summary     = "CMS"
  s.description = "CMS on Ruby on Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,tasks,node_modules}/**/*", "MIT-LICENSE", "Rakefile", "readme.md"]
  s.test_files = Dir["spec/**/*"]


  s.add_dependency "rails", ">= 5.0.5"

  s.add_dependency "friendlycontent-rails"
  s.add_dependency "friendlycontent-source"

  s.add_dependency "devise", '>=4.0'
  s.add_dependency 'webpacker', '~> 3.5'
  s.add_dependency "haml-rails", ">= 0.9.0"
  #s.add_dependency "sass-rails", '>= 5.0.4'
  #s.add_dependency "jquery-rails" #, "~> 4.0.3"
  #s.add_dependency "jquery-ui-rails"
  #s.add_dependency "coffee-rails" #, "~>4.1.0"
  #s.add_dependency "uglifier"
  #s.add_dependency "font-awesome-rails" #, '~> 4.3'
  s.add_dependency 'paperclip'
  s.add_dependency 'ancestry'
  s.add_dependency 'globalize'
  #s.add_dependency 'activemodel-serializers-xml', '1.0.1'
  #s.add_dependency 'globalize-accessors'
  s.add_dependency 'simple_form'
  s.add_dependency 'simple_search_filter' #, '>=0.1.1'
  s.add_dependency 'bootstrap_autocomplete_input', '>=0.2.0'
  s.add_dependency 'tinymce-rails'
  s.add_dependency 'el_finder'

  # test
  s.add_development_dependency "mysql2", '~> 0'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
