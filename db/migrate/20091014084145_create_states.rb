################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.integer :state
      t.text    :explaination

      t.timestamps
    end
  end

  def self.down
    drop_table :states
  end
end
