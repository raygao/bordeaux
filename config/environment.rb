################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Removed due to conflicts with acts_as_state_machine
# see http://github.com/jkraemer/acts_as_ferret
require 'acts_as_ferret'
ActsAsFerret.index_dir = "#{RAILS_ROOT}/search_index"

# See http://rubyforge.org/projects/spreadsheet/
require 'spreadsheet'

# tutorial - http://learningrubyonrails.blogspot.com/2007/03/acts-as-state-machine-plugin.html
# github - http://github.com/omghax/acts_as_state_machine/
require 'acts_as_state_machine'

require 'action_mailer'

Rails::Initializer.run do |config|

  # you can pick with mark-down to use, defaulting to RedCloth
  config.gem 'RedCloth'
  #config.gem 'bluecloth'

  #if not using WillPaginate as a plugin, I can use GemCutter (remote) gem.
  #config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
  #
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake time:zones:all" for a list of tasks for finding time zone names.
  # see http://www.slideshare.net/keithpitty/whats-new-in-rails-21
  #config.time_zone = 'UTC'
  config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Date format, see http://www.practicalecommerce.com/blogs/post/96-Custom-Date-Output-Using-Rails
  # ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:standard => "%B %d, %Y")
  # ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:standard => "%B %d, %Y")
  # :fmt_date is used in the project, to make more friend Date display, in
  # listings/show_submitted.fbml.erb, admin/expire_stale_listings.fbml.erb
  # home/index.fbml.erb, listings/inex.fbml.erb, and listings/show.fbml.erb
  Time::DATE_FORMATS[:fmt_date] = "%A, %B %d, %Y"

  # using Database to store session, primary for sharin session across mongrel servers
  # This is a fix for ADMIN status being lost across mongrel clusters.
  # See http://www.oopcenter.com/article/ruby-on-rails/tracking-sessions-in-ruby-on-rails-in-all-situations.html
  # next use command -> RAILS_ENV=production rake db:sessions:create
  config.action_controller.session_store = :active_record_store  
end

