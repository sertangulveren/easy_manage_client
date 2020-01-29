# frozen_string_literal: true

require 'simplecov'
require 'webmock/minitest'

SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

TEST_AUTH_TOKEN = 'yes.thisismytopsecretkeylol'
require 'easy_manage_client'

require 'minitest/autorun'

# Create a default configuration for tests.
def configure_default_profile
  # Default profile is :default.
  # We can create another configuration like:
  # ::EasyManageClient.configure(:settings)
  ::EasyManageClient.configure do |config|
    config.root_url = 'https://easymanage.example.com'
    config.auth_token = TEST_AUTH_TOKEN # defined in test_helper.rb
    config.extension = 'yaml'
    # config.download_folder = "#{Rails.root}/config/translations"
    config.download_folder = File.join(Dir.pwd, 'tmp')
  end
end

# Example profile name for compiled version: :powderduction
def configure_compiled_version_profile
  ::EasyManageClient.configure(:powderduction) do |config|
    config.root_url = 'https://easymanage.example.com'
    config.auth_token = TEST_AUTH_TOKEN # defined in test_helper.rb
    config.extension = 'yaml'
    config.download_folder = File.join(Dir.pwd, 'tmp')
    config.compile_id = '5e0799592444960017069ef1'
  end
end

# Standard response data for tests
def standard_mock_data
  {
    reference: '5e0799592444960017069ef1',
    content: '{"about":"Aliqua eiusmod velit ea ad sint in voluptate '\
             'laboris proident.","tags":["elit","sit"],'\
             '"elements":[{"name":"Take Five"}]}'
  }
end

# Definition generates responses for api calls.
def genarete_request_stub_for(root_url, req_uri, extension)
  stub_request(:get, "#{root_url}#{req_uri}?version=#{extension}").to_return(
    status: 200,
    body: standard_mock_data.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )
end

# Definition generates broken responses for api calls.
def genarete_broken_stub_for(root_url, req_uri, extension)
  stub_request(:get, "#{root_url}#{req_uri}?version=#{extension}").to_return(
    status: 200,
    body: '{"referrrrrrence": "314124900925jfw3413", "content": "{}" }',
    headers: { 'Content-Type' => 'application/json' }
  )
end

# Definition generates timeouts for api calls.
def genarete_timeout_stub_for(root_url, req_uri, extension)
  stub_request(:get, "#{root_url}#{req_uri}?version=#{extension}").to_timeout
end
