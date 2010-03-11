################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class RemoveStateIdFromListing < ActiveRecord::Migration
  def self.up
    remove_column :listings, :state_id
  end

  def self.down
    add_column :listings, :state_id, :integer
  end
end
