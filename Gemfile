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

gem 'rails', '~> 5.1.6'

gem 'mysql2', '0.4.10'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'


gem 'puma', '~> 3.0'

gem 'globalize', github: 'globalize/globalize'
gem 'activemodel-serializers-xml'
gem 'globalize-accessors'


#
gem 'devise', '4.3.0'

if Bundler::WINDOWS
  gem 'bcrypt-ruby', '3.1.1.rc1', :require => 'bcrypt'
else
  gem 'bcrypt', '~> 3.1.10', require: false
end
gem 'net-ssh', '3.1.1', :git => 'https://github.com/maxivak/net-ssh', :branch => '3-1-release'




gem 'webpacker', '3.5.3'

gem 'haml-rails', '1.0.0'

#gem 'sass-rails' #, '~>5.0.6'
#gem 'uglifier', '3.2.0'
#gem 'coffee-rails'
#gem 'jquery-rails'
#gem 'font-awesome-rails'



# Tooltips and popovers depend on tether for positioning. If you use them, add tether to the Gemfile:
#source 'https://rails-assets.org' do
#  gem 'rails-assets-tether', '>= 1.3.3'
#end

#
gem 'kaminari'
gem 'kaminari-bootstrap'


gem 'simple_form', '3.5.0' #, '~>3.3.1'
gem 'simple_search_filter', '0.1.1'
gem 'bootstrap_autocomplete_input', '~>0.2.0'


gem 'paperclip'
gem 'ancestry'




# tinymce
gem 'tinymce-rails', '4.7.13' #, '4.1.6'


# editor
gem 'el_finder', '1.1.13'

#
group :development, :test do
  gem 'rspec-rails' #, '3.1.0'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'capybara'
#gem "capybara-webkit"
#gem 'selenium-webdriver'
end


group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

end

