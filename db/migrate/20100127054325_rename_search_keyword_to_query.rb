################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class RenameSearchKeywordToQuery < ActiveRecord::Migration
  def self.up
    rename_column(:searches, :keyword, :query)
  end

  def self.down
    rename_column(:searches, :query, :keyword)
  end
end
