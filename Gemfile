# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'hashdiff', '~> 0.4.0'
gem 'httparty', '~> 0.17.0'
gem 'rspec', '~> 3.8'
gem 'rubocop', '~> 0.70.0', require: false

group :development, :test do
  gem 'pry', '~> 0.12.2'
  gem 'pry-byebug', '~> 3.7'
end

group :test do
  gem 'webmock', '~> 3.5'
end
