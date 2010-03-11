################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class User < ActiveRecord::Base
  include FacebookerAuthentication::Model

  has_many :listings, :dependent => :destroy
end
