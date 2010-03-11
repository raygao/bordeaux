################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class PhotosUseAttachmentFu < ActiveRecord::Migration
  def self.up
    add_column :photos, :title, :string
    add_column :photos, :parent_id, :integer
    add_column :photos, :content_type, :string
    add_column :photos, :filename, :string
    add_column :photos, :thumbnail, :string
    add_column :photos, :size, :integer
    add_column :photos, :width, :integer
    add_column :photos, :height, :integer
    add_column :photos, :large_fb_image, :string
    add_column :photos, :small_fb_image, :string
  end

  def self.down
    remove_column :photos, :title
    remove_column :photos, :parent_id
    remove_column :photos, :content_type
    remove_column :photos, :filename
    remove_column :photos, :thumbnail
    remove_column :photos, :size
    remove_column :photos, :width
    remove_column :photos, :height
    remove_column :photos, :large_fb_image
    remove_column :photos, :small_fb_image
  end
end
