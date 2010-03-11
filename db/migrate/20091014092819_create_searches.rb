################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :title
      t.string :keyword

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
