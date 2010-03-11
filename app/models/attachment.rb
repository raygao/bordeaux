################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class Attachment < ActiveRecord::Base
  belongs_to :listing
  has_attachment  :storage => :file_system,
    :max_size => 10120.kilobytes
    #:content_type => :all

  validates_as_attachment
end
