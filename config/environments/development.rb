################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Raise the error when it happens, either true or false
config.action_mailer.raise_delivery_errors = true

#see RAILS_ROOT/libs/constants.rb

# see http://caboo.se/doc/classes/ActionController/RequestForgeryProtection/ClassMethods.html
config.action_controller.allow_forgery_protection = false

#constants for home URL redict
APP_ENV = 'dev' # see user_publisher.rb
FB_APP_HOME_URL = "http://apps.facebook.com/bordeaux_dev"

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