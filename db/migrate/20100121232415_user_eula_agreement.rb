################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class UserEulaAgreement < ActiveRecord::Migration
  def self.up
    add_column :users, :eula_status, :boolean
  end

  def self.down
    remove_column :users, :eula_status
  end
end
