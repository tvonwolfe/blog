source "https://rubygems.org"

ruby "4.0.1"

gem "bcrypt", "~> 3.1.21"
gem "bootsnap", require: false
gem "commonmarker"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "jwt"
gem "pagy", "~> 9.4.0"
gem "pg", "~> 1.1"
gem "phlex-rails"
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", "~> 8.1.2"
gem "redis"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "brakeman", require: false
  gem "capybara"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "nokogiri"
  gem "rspec-rails", "~> 8.0"
  gem "rubocop-rails-omakase", require: false
  gem "selenium-webdriver"
  gem "testy_cookie"
end

group :development do
  gem "ruby-lsp", require: false
  gem "ruby-lsp-rails", require: false
  gem "ruby-lsp-rspec", require: false
  gem "web-console"
end

gem "aws-sdk-s3", require: false
gem "marksmith", "~> 0.4.8"

# activesupport still uses positional arguments to initialize ConnectionPool
# objects. connection_pool v3.0 and up now uses keyword arguments.
# pinning to the last pre-3.0 version until activesupport updates their usages.
gem "connection_pool", "~>3.0.2"
