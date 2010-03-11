################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.binary      :picture
      t.integer     :listing_id

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
