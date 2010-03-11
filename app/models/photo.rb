################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class Photo < ActiveRecord::Base
  belongs_to :listing
  has_attachment  :storage => :file_system,
                  :max_size => 5120.kilobytes,
                  :resize_to => '600x800>',
                  :thumbnails => { :thumb => '50x50>' },
                  :content_type => :image
                  #:storage => :facebooker,

  validates_as_attachment
end
