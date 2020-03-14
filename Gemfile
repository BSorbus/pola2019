source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
#gem 'puma', '~> 3.11'
gem 'puma', '~> 4.3.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby
#gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'brakeman', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'rails-i18n'
gem 'bootstrap-sass', '3.4.1'

gem 'fullcalendar-rails'

gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'

gem 'jquery-rails'
gem 'font_awesome5_rails'
gem 'select2-rails', '3.5.9.3'

gem 'redis-rails'
gem "hiredis"
gem "redis", "~> 4.0"

#gem 'jquery-datatables', '~> 1.10.20' 
gem 'jquery-datatables', '= 1.10.19.1' #'=1.10.20 bo' z .19 jest jakis problem z wyswietlaniem kolumn wyboru
gem 'ajax-datatables-rails' #, '= 0.4.0' jeżeli wywala się na custom_filter
gem 'kaminari'

gem "devise", ">= 4.7.1"
gem 'devise-security'
gem 'rails_email_validator'
gem 'pundit'

gem 'carrierwave', '~> 2.0'
gem 'mini_magick'
gem 'jquery-fileupload-rails'
gem 'file_validators'
gem 'activerecord-import'

gem "actionpack-page_caching"
gem "actionpack-action_caching"

gem 'piwik_analytics'

# gem 'chartkick'
# gem 'groupdate'

# gem 'rack-cors', :require => 'rack/cors'
gem 'rack-attack'
gem 'mina'

gem 'inky-rb', require: 'inky'
gem 'premailer-rails'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'trix-rails', require: 'trix'

gem 'mini_exiftool'
gem 'closure_tree'