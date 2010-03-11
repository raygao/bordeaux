################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

#see RAILS_ROOT/libs/constants.rb

# see http://caboo.se/doc/classes/ActionController/RequestForgeryProtection/ClassMethods.html
config.action_controller.allow_forgery_protection = false

#constants for home URL redict
APP_ENV = 'test' # see user_publisher.rb
FB_APP_HOME_URL = "http://apps.facebook.com/bordeaux_test"

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