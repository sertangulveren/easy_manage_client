# frozen_string_literal: true

module EasyManageClient
  # Downloader
  class Downloader < Core
    # It decides which api endpoint to use and returns this endpoit.
    def request_uri
      # if version not specified, use latest uri
      if ::EasyManageClient.configuration(profile).compile_id.nil?
        return latest_version_uri
      end

      # generate compiled_version_uri
      compiled_version_uri
    end

    # Call api, handle response, perform all actions according to success.
    # Method returns true or false.
    def perform
      # make api call and handle response
      super

      # If success is not true, stop operation and return false.
      return false unless success

      # Download data to the relevant location.
      write_to_folder
      true
    end

    # CRASH! If unsuccessful.
    def perform!
      perform
      unless success
        raise ::EasyManageClient::DownloadProcessFailed, response[:message]
      end

      # Everything is OK.
      true
    end

    # Returns request uri from specified version.
    def compiled_version_uri
      '/api/projects/by_reference/' +
        ::EasyManageClient.configuration(profile).compile_id.to_s
    end

    # Returns request uri for latest version.
    def latest_version_uri
      '/api/projects/latest_compiled_version'
    end

    # Write content to download folder.
    def write_to_folder
      File.open(prepare_file_path_to_download, 'w') do |file|
        file.write(response[:content])
      end
    end

    # Prepares a file path from the specified extension and download folder.
    def prepare_file_path_to_download
      folder = ::EasyManageClient.configuration(profile).download_folder
      file_extension = ::EasyManageClient.configuration(profile).file_extension
      File.join(folder, "#{response[:reference]}.#{file_extension}")
    end
  end
end
