# frozen_string_literal: true

require 'faraday'
require 'easy_manage_client/version'
require 'easy_manage_client/configuration'
require 'easy_manage_client/core'
require 'easy_manage_client/downloader'
require 'easy_manage_client/railtie' if defined?(Rails)

module EasyManageClient
  class Error < StandardError; end
  class InvalidResponseContent < Error; end
  class ProfileNotFound < Error; end
  class InvalidExtension < Error; end
  class NoProfilesWereFound < Error; end
  class DownloadProcessFailed < Error; end
end
