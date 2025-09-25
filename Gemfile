source "https://rubygems.org"

# Rails
gem "rails", "~> 8.0.2", ">= 8.0.2.1"

# Asset pipeline
gem "propshaft"

# Database
gem "sqlite3", ">= 2.1"

# Web server
gem "puma", ">= 5.0"

# JavaScript (import maps)
gem "importmap-rails"

# Hotwire
gem "turbo-rails"
gem "stimulus-rails"

# JSON API builder
gem "jbuilder"

# Authentication (password hashing)
gem "bcrypt", "~> 3.1.7"

# CORS (allow Retool / RPC backend to call your API)
gem "rack-cors"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Rails caching, jobs, websockets
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Faster boot
gem "bootsnap", require: false

# Deployment tools
gem "kamal", require: false
gem "thruster", require: false

# Active Storage variants
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Security analysis
  gem "brakeman", require: false

  # Rails linting
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Console on exception pages
  gem "web-console"
end

group :test do
  # System testing
  gem "capybara"
  gem "selenium-webdriver"
end
