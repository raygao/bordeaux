################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

#### Note: Facebook Event creation is pretty weird ####
# see following references:
# (available parameters of the 'event_info' object ->  http://wiki.developers.facebook.com/index.php/Events.create
# 'FacebookerWorker' is a good reference that works -> http://www.ruby-forum.com/attachment/3606/facebook_worker.rb
# Discussions on http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/98fd20ee9bfe0903
# Facebook Error Code ->  http://wiki.developers.facebook.com/index.php/Error_codes
# Note: must enable 'create_event' -> http://wiki.developers.facebook.com/index.php/Fb:prompt-permission
# This has been done in the 'layout/application.fbml.erb'

class Event < ActiveRecord::Base
  belongs_to :listing
end
