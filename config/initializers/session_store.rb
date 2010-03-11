# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bordeaux_session',
  :secret      => '07be2b672bad9bf39ca0dd54b485f27662275b94785b68a8f1472181e73ea650cd36defaa21527c5e048a3ecd8f1a1ad549280996653cc4f6a419fe4a8e28b0f'
}

=begin
ActionController::Base.session = {
  :key         => '_porchbbs235_session',
  :secret      => '07be2b672bad9bf39ca0dd54b485f27662275b94785b68a8f1472181e73ea650cd36defaa21527c5e048a3ecd8f1a1ad549280996653cc4f6a419fe4a8e28b0f'
}
=end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
