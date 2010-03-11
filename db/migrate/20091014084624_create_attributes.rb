################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreateAttributes < ActiveRecord::Migration
  def self.up
    create_table :attributes do |t|
      t.text      :value
      t.integer   :listing_id
      t.integer   :attribute_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :attributes
  end
end
