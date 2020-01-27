# frozen_string_literal: true

require 'test_helper'
module EasyManageClient
  class DownloaderTest < Minitest::Test
    def setup
      configure_default_profile
      @downloader = ::EasyManageClient::Downloader.new
    end

    def test_latest_version_download_must_be_successful
      genarete_request_stub_for(::EasyManageClient.configuration.root_url,
                                @downloader.request_uri,
                                ::EasyManageClient.configuration.extension)

      assert @downloader.perform
    end

    def test_compiled_version_download_must_be_successful
      configure_compiled_version_profile
      @downloader = ::EasyManageClient::Downloader.new(profile: :powderduction)
      genarete_request_stub_for(
        ::EasyManageClient.configuration(:powderduction).root_url,
        @downloader.request_uri,
        ::EasyManageClient.configuration(:powderduction).extension
      )

      assert @downloader.perform
    end

    def test_request_must_be_time_out
      genarete_timeout_stub_for(::EasyManageClient.configuration.root_url,
                                @downloader.request_uri,
                                ::EasyManageClient.configuration.extension)
      # Must be return false
      refute @downloader.perform
    end

    def test_timeout_exception_message_must_be_handled
      genarete_timeout_stub_for(::EasyManageClient.configuration.root_url,
                                @downloader.request_uri,
                                ::EasyManageClient.configuration.extension)
      refute @downloader.perform

      # Message must be timeout message.
      assert_equal 'execution expired', @downloader.response[:message]
    end

    def test_response_content_must_be_broken
      genarete_broken_stub_for(::EasyManageClient.configuration.root_url,
                               @downloader.request_uri,
                               ::EasyManageClient.configuration.extension)
      refute @downloader.perform

      # Message must be broken response message.
      assert_equal 'Invalid response from the server.',
                   @downloader.response[:message]
    end
  end
end
