source 'https://rubygems.org'

# Declare your gem's dependencies in optimacms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

ruby '2.6.6'

gem 'rails', '6.0.2.1'

gem 'zeitwerk', '2.3.0'

gem 'mysql2', '0.5.2'

# Use Puma as the app server
group :development, :test do
  gem 'puma', '~> 3.11'
end

gem 'nokogiri', '1.10.10'

#
gem 'devise', '4.7.1'

if Bundler::WINDOWS
  #gem 'bcrypt-ruby', '~> 3.0.0', require: false
  gem 'bcrypt-ruby', '3.1.1.rc1', :require => 'bcrypt'
else
  gem 'bcrypt', '~> 3.1.10', require: false
end

gem 'net-ssh', '5.2.0'

gem 'globalize', github: 'globalize/globalize'
gem 'activemodel-serializers-xml'
gem 'globalize-accessors'


gem 'haml-rails', '1.0.0'
gem 'sass-rails', '>=6'
#gem 'uglifier', '3.2.0'
#gem 'coffee-rails'
#gem 'jquery-rails'
#gem 'font-awesome-rails'

gem 'rails-i18n', '6.0.0'



gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'


gem 'kaminari'
gem 'kaminari-bootstrap'

gem 'simple_form', '4.1.0'
#gem 'simple_form', '3.5.0' #, '~>3.3.1'
gem 'simple_search_filter', '0.2.1'
gem 'bootstrap_autocomplete_input', '0.2.4'

gem 'paperclip', '6.1.0'
gem 'ancestry'

# tinymce
gem 'tinymce-rails', '4.7.13' #, '4.1.6'

# editor
gem 'el_finder', '1.1.13'


gem 'tzinfo', '1.2.7'
gem 'tzinfo-data', '1.2020.1'

#
group :development do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

end


group :test do
  gem 'rspec-rails' #, '3.1.0'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'capybara'
#gem "capybara-webkit"
#gem 'selenium-webdriver'

end