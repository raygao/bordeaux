################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################
require RAILS_ROOT + "/config/constants"

class Photo < ActiveRecord::Base
  belongs_to :listing
  has_attachment  :storage => :file_system,
                  :max_size => MAX_FILE_UPLOAD_SIZE,
                  :path_prefix => ATTACHMENT_FU_ROOT + "/photos",
                  :resize_to => PHOTO_SIZE + '>',
                  :thumbnails => { :thumb => THUMBNAILS_SIZE + '>' },
                  :content_type => :image
                  #:storage => :facebooker,

  validates_as_attachment
end
