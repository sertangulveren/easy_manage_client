# frozen_string_literal: true

require 'easy_manage_client'
namespace :easy_manage_client do
  desc 'Download the dump.'
  task :download do
    profile = ENV.fetch('PROFILE', :default).to_sym
    puts "EasyManageClient running for: #{profile}"
    downloader = ::EasyManageClient::Downloader.new(profile: profile)
    puts "EasyManageClient processing for: #{profile}"
    downloader.perform!
    puts "EasyManageClient process successfully completed for: #{profile}"
  end
end
