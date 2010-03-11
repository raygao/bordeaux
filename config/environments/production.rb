################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

#see RAILS_ROOT/libs/constants.rb

# see http://caboo.se/doc/classes/ActionController/RequestForgeryProtection/ClassMethods.html
config.action_controller.allow_forgery_protection = false

#constants for home URL redict
APP_ENV = 'prod' # see user_publisher.rb
FB_APP_HOME_URL = "http://apps.facebook.com/bordeaux"

# ActionMailer setting if using environment.rb
# ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address        => "<mailserver>",
  :port           => 587,
  :domain         => "<mailserver>",
  :user_name      => "<username>",
  :password       => "<password>",
  :enable_starttls_auto => true,
  :authentication => :plain
}
# :authentication can be either :plain, :login, :cram_md5, but :login is the only one seems to be working with yahoo.com
=begin
config.action_mailer.smtp_settings = {
  :address        => "plus.smtp.mail.yahoo.com",
  :port           => 587,
  :domain         => "www.yahoo.com",
  :user_name      => "xxxxx",
  :password       => "xxxxx",
  :authentication => :login
}
=end