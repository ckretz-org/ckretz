source "https://rubygems.org"

ruby "3.3.1"

gem "rails", "~> 7.1.3"

gem "propshaft"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5.6"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.2"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

gem "jwt"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "rls_rails", github: "sbiastoch/rls_rails", branch: "master"

gem "rails-pg-extras"

gem "omniauth"
gem "omniauth-github", "~> 2.0.0"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "dry-struct"

gem "openfeature-sdk"
#https://github.com/open-feature/ruby-sdk-contrib/tree/main/providers/openfeature-flagd-provider
gem "openfeature-flagd-provider", github: "open-feature/ruby-sdk-contrib", glob: "providers/openfeature-flagd-provider/openfeature-flagd-provider.gemspec"

group :development, :test do
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rswag-specs"
  gem "rubycritic", require: false
  gem "rubocop", "~> 1.60", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-performance", require: false
  gem "guard-rubocop"
  gem "guard"
  gem "guard-rspec", require: false
  gem "guard-rubycritic", require: false
  gem "guard-process"
  gem "standard"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "spring"
  gem "listen"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rspec-rails"
  gem "faraday-retry"
  gem "factory_bot_rails"
  gem "faker"
  gem "simplecov"
  gem "simplecov-console"
  gem "simplecov-csv"
  gem "pundit-matchers"
  gem "shoulda-matchers"
  gem "webmock"
  gem "rspec-parameterized", ">= 1.0.0"
  gem "spring-commands-rspec"
end
