source 'http://rubygems.org'
def mac?
  RUBY_PLATFORM =~ /darwin/
end

gem 'rails', '>= 3.0.0'
gem 'arel',  '>= 0.4.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# debugger
gem 'ruby-debug19'

# views
gem 'haml'
gem 'haml-rails'

# devise
gem 'devise', '>= 1.1.2'

# rdiscount
gem 'rdiscount'

# mongo
gem 'mongoid', :path => '/Users/thenrio/src/ruby/mongoid'
gem 'bson_ext', '~> 1.1'
gem 'mongo', '~> 1.1'

group :development, :test do
  gem "rspec-rails", ">= 2.0.0.rc"
end

group :test do
  gem "rspec_tag_matchers"
  gem 'wrong', '>= 0.4.0'

  # factory
  gem 'fabrication'

  # cucumber
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'database_cleaner'

  # spork, drb server
  gem 'spork', '>= 0.9.0.rc2'

  # capybara
  gem 'capybara'
  gem 'launchy'
  
  # watchr is an alternate to autotest ...
  gem 'watchr'

  # rr
  gem 'rr'

  # coverage
  gem 'simplecov', :require => false if RUBY_VERSION =~ /1\.9/
end
