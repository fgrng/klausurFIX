# ===============
# === Gemfile ===
# ===============

# --- Standard Gem Source
source 'https://rubygems.org'

# --- Base
gem 'rails', '4.2.1'

# =================
# === Configure ===
# =================

# --- Database
gem 'sqlite3'
# gem 'pg'
# gem 'mysql2'

# --- Webserver
# gem 'fcgi'
gem 'thin'

# =================
# =================
# =================

# --- JavaScript
gem 'jquery-rails'
gem 'jbuilder'
gem 'therubyracer', platforms: :ruby
gem 'execjs'
gem 'coffee-rails'
gem 'uglifier'

# --- CSS and Twitter Bootstrap
gem 'sprockets-rails', '>= 2.3.2'
gem 'sass', '>= 3.4.18'
gem 'sass-rails', '>= 4.0.0'
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem' # Twitter 4 alpha

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

# gem 'bootstrap-sass', '~> 3.1.1'
# gem 'bootstrap_form', :git => 'git://github.com/bootstrap-ruby/rails-bootstrap-forms.git'
# gem "bootstrap-switch-rails"

# -- Internationalization
gem 'rails-i18n'

# --- Other gems
gem 'bcrypt', '~> 3.1.7'
gem 'turbolinks'
gem 'slim-rails'
gem 'draper', '~> 1.3'
gem 'will_paginate'
gem 'rb-readline'

group :development do
	gem 'awesome_print'       # console highlighting
	gem 'better_errors'       # improve in browser error messages
	gem 'meta_request'        # show log in Chrome dev tools with RailsPanel addon
	gem 'pry'
	gem 'pry-doc'
	gem 'method_source'
	gem 'binding_of_caller'
	gem 'hirb-unicode'
end

group :production do
end
