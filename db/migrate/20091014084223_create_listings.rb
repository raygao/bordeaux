################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.string    :title
      t.text      :description
      t.integer   :user_id
      t.integer   :category_id
      t.integer   :state_id

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
