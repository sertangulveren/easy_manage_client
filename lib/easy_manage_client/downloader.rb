# frozen_string_literal: true

module EasyManageClient
  # Downloader
  class Downloader < Core
    def request_uri
      # if version not specified, use latest uri
      if ::EasyManageClient.configuration(profile).compile_id.nil?
        return latest_version_uri
      end

      # generate compiled_version_uri
      compiled_version_uri
    end

    def perform
      # make api call and handle response
      super
      # if success is not true
      # stop operation and return false
      return false unless success

      # download data to the relevant location
      write_to_folder
      true
    end

    def perform!
      perform
      unless success
        raise ::EasyManageClient::DownloadProcessFailed, response[:message]
      end

      true
    end

    def compiled_version_uri
      '/api/projects/by_reference/' +
        ::EasyManageClient.configuration(profile).compile_id.to_s
    end

    def latest_version_uri
      '/api/projects/latest_compiled_version'
    end

    def write_to_folder
      File.open(prepare_file_path_to_download, 'w') do |file|
        file.write(response[:content])
      end
    end

    def prepare_file_path_to_download
      folder = ::EasyManageClient.configuration(profile).download_folder
      extension = ::EasyManageClient.configuration(profile).extension
      File.join(folder, "#{response[:reference]}.#{extension}")
    end
  end
end
