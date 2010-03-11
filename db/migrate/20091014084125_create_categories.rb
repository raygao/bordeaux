################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
