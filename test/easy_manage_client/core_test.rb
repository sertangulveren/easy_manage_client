# frozen_string_literal: true

require 'test_helper'
module EasyManageClient
  class CoreTest < Minitest::Test
    def setup
      configure_default_profile
      @core_object = ::EasyManageClient::Core.new
    end

    def test_an_error_must_occur_if_profile_not_defined
      # We configured without specify a profile on setup
      # If the profile is not specified in the configuration,
      # the default profile name will be called :default
      # :settings not defined
      assert_raises EasyManageClient::ProfileNotFound do
        ::EasyManageClient::Core.new(profile: :settings)
      end
    end

    def test_core_class_should_be_initialized
      # The Core class should be able to initialize on its own.
      assert ::EasyManageClient::Core.new(profile: :default)
      # default profile is :default.
      assert ::EasyManageClient::Core.new
    end

    def test_token_generation_must_be_correct
      assert @core_object.generate_bearer_token.include?(
        ::EasyManageClient.configuration.auth_token
      )
    end

    def test_headers_must_be_correct
      assert @core_object.headers.key?('Authorization')
      assert @core_object.headers['Authorization'].include?(
        ::EasyManageClient.configuration.auth_token
      )
    end

    def test_params_must_be_correct
      assert @core_object.params.key?(:version)
      assert_equal ::EasyManageClient.configuration.extension,
                   @core_object.params[:version]
    end
  end
end
