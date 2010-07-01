# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tehnotochka_session',
  :secret      => 'afdd4a17a268c870aa3f725fcbaf9940bee25785ed63dfd203af8e1360a0dd1199e245d74b787bca0d967c8fb5d9e3a5ec0c7e900fdc8236b6cb5768457d8385'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store