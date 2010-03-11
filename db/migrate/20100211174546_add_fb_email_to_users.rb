################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class AddFbEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_email, :text
  end

  def self.down
    remove_column :users, :fb_email
  end
end
