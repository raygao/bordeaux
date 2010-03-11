################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.text :title
      t.text :facebook_title
      t.text :description
      t.text :category
      t.text :subcategory
      t.text :location
      t.text :street
      t.text :city
      t.text :privacy_type
      t.datetime :start_time
      t.datetime :end_time
      t.text :phone
      t.text :email
      t.integer :page_id
      t.text :tagline
      t.text :host
      t.integer :listing_id
      t.text :facebook_event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
