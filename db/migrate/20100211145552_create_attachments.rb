################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.text    :title
      t.integer :size
      t.text    :content_type
      t.text    :filename
      t.integer :height
      t.integer :width
      t.integer :parent_id
      t.text    :thumbnail
      t.integer :listing_id


      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
