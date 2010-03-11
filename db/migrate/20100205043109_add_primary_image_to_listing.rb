################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class AddPrimaryImageToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :primary_image_id, :integer
  end

  def self.down
    remove_column :listings, :primary_image_id
  end
end
