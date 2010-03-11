################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class Attribute < ActiveRecord::Base
  belongs_to :listing
  belongs_to :attribute_type
end
