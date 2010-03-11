################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

# call: $ RAILS_ENV=test ./script/runner "SessionCleaner.remove_stale_sessions"
# where RAILS_ENV can be test, production, development
require 'active_record'
class SessionCleaner
  def self.remove_stale_sessions
    ActiveRecord::SessionStore::Session.destroy_all( ['updated_at < ?', DateTime.now()] )
  end
end

=begin
    # Remove stale old sessions from the SESSIONS db.
  require 'rubygems'
  require 'mysql'

  db = Mysql.new("localhost", "db_user", "db_pass", "db_name")
  #query = db.prepare("DELETE FROM `sessions` WHERE updated_at < NOW() - INTERVAL 20 MINUTE")
  query = db.prepare("DELETE FROM `sessions` WHERE CREATED_AT < (SELECT CONVERT_TZ(NOW(),'+00:00','+7:00'));")

  query.execute
  puts "********Removed #{query.affected_rows} Sessions*****\n"
  db.close
=end
