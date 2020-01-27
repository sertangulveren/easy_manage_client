# frozen_string_literal: true

require 'easy_manage_client'
require 'rails'

module EasyManageClient
  # Railtie
  class Railtie < Rails::Railtie
    railtie_name :easy_manage_client

    rake_tasks do
      load 'tasks/easy_manage_client.rake'
    end
  end
end
