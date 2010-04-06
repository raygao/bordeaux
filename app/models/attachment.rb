################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################
require RAILS_ROOT + "/config/constants"

class Attachment < ActiveRecord::Base
  belongs_to :listing
  has_attachment  :storage => :file_system,
    :path_prefix => ATTACHMENT_FU_ROOT + "/attachments",
    :max_size => MAX_FILE_UPLOAD_SIZE
    #:content_type => :all

  validates_as_attachment
end
