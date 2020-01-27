# frozen_string_literal: true

require 'test_helper'
require 'rake'
load('lib/tasks/easy_manage_client.rake')
module EasyManageClient
  class TasksTest < Minitest::Test
    def setup
      configure_default_profile
      @downloader = ::EasyManageClient::Downloader.new
      Rake::Task['easy_manage_client:download'].reenable
    end

    def test_rake_task_must_be_successfully_completed
      success_stub
      assert Rake::Task['easy_manage_client:download'].invoke
    end

    def test_rake_task_must_be_crash_on_timeout
      timeout_stub
      assert_raises ::EasyManageClient::DownloadProcessFailed do
        Rake::Task['easy_manage_client:download'].invoke
      end
    end

    def test_rake_task_must_be_crash_on_broken_response
      broken_stub
      assert_raises ::EasyManageClient::DownloadProcessFailed do
        Rake::Task['easy_manage_client:download'].invoke
      end
    end

    def test_rake_task_must_be_crash_if_profile_not_defined
      ENV['PROFILE'] = 'compile_2019'
      assert_raises ::EasyManageClient::ProfileNotFound do
        Rake::Task['easy_manage_client:download'].invoke
      end
      # We set it to nil so that it does not affect other tests.
      ENV['PROFILE'] = nil
    end

    def success_stub
      genarete_request_stub_for(
        ::EasyManageClient.configuration.root_url,
        @downloader.request_uri,
        ::EasyManageClient.configuration.extension
      )
    end

    def timeout_stub
      genarete_timeout_stub_for(
        ::EasyManageClient.configuration.root_url,
        @downloader.request_uri,
        ::EasyManageClient.configuration.extension
      )
    end

    def broken_stub
      genarete_broken_stub_for(
        ::EasyManageClient.configuration.root_url,
        @downloader.request_uri,
        ::EasyManageClient.configuration.extension
      )
    end
  end
end
