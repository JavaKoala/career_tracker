source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# Use delayed_job for background processing
gem 'daemons', '~> 1.4'
gem 'delayed_job_active_record', '~> 4.1'
gem 'rush_job', '~> 1.3'

# Use faraday for HTTP requests
gem 'faraday', '~> 2.13'

# Use ruby-openai for LLM API
gem 'ruby-openai', '~> 8.1'

# Use Pagy for pagination [https://ddnexus.github.io/pagy/]
gem 'pagy', '~> 9.3'

# Use influxdb for instrumentation
gem 'influxdb-client', '~> 3.2'

# Use CSV safe for safe CSV generation
gem 'csv-safe', '~> 3.3'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Use FactoryBot for fixtures
  gem 'factory_bot_rails'

  # Use Robcop for linting
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false

  # Use RSpec for testing
  gem 'rspec-rails', '~> 8.0'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.32'
  gem 'shoulda-matchers', '~> 6.5'
  gem 'simplecov', require: false
  gem 'webmock'
end
