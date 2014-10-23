# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

WeddingApp::Application.config.secret_key_base = secure_token

# WeddingApp::Application.config.secret_key_base = 'e14b226fabd1cdca7ed12eb46233280591543d8708c1035d9ad36a5bc9d2de0d9786d4033c9f2f461db6d49332c6dc72d2663e13fd8c0084a6d1bff5d295ab91'
