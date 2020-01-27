# frozen_string_literal: true

require 'test_helper'
module EasyManageClient
  class ConfigurationTest < Minitest::Test
    def setup
      configure_default_profile # defined in test_helper.rb
    end

    def test_config_root_url_must_be_correct
      assert_equal 'https://easymanage.example.com',
                   ::EasyManageClient.configuration.root_url
    end

    def test_config_auth_token_must_be_correct
      assert_equal TEST_AUTH_TOKEN, ::EasyManageClient.configuration.auth_token
    end

    def test_config_extension_must_be_correct
      assert_equal 'yml', ::EasyManageClient.configuration.extension
    end

    def test_config_profile_must_be_correct
      # We didn't specified the profile name in configuration.
      # Therefore, the profile name must be :default.
      assert_equal :default, ::EasyManageClient.configuration.profile
    end

    def test_an_error_must_occur_if_profile_not_defined
      # We configured without specify a profile on setup
      # If the profile is not specified in the configuration,
      # the default profile name will be called :default
      # :translation_repo not defined
      assert_raises ::EasyManageClient::ProfileNotFound do
        ::EasyManageClient.configuration(:translation_repo)
      end
    end

    def test_if_profile_is_defined_there_must_be_no_errors
      assert ::EasyManageClient.configuration(:default)
      # if not specified, uses :default
      assert ::EasyManageClient.configuration
    end
  end
end
