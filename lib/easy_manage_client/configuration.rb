# frozen_string_literal: true

# main module
module EasyManageClient
  class << self
    attr_accessor :configurations

    def configuration(profile = :default)
      raise NoProfilesWereFound if configurations.nil? || configurations.empty?

      configurations.select do |conf|
        conf.profile == profile
      end.first || raise(ProfileNotFound, "Undefined profile: #{profile}")
    end

    private

    def reject_profile(profile)
      configurations.reject! { |conf| conf.profile == profile }
    end

    def initialize_configuration
      self.configurations = [] if configurations.nil?
      Configuration.new
    end

    def after_configuration_events(conf, profile)
      conf.profile = profile # FORCE!
      conf.check!
      reject_profile(profile)
      configurations << conf
    end
  end

  def self.configure(profile = :default)
    conf = initialize_configuration
    yield(conf)
    after_configuration_events(conf, profile)
  end

  # Configuration class
  class Configuration
    EXTENSION_TYPES = %w[yaml json].freeze
    FILE_EXTENSION_TYPES = { 'yaml' => 'yml', 'json' => 'json' }.freeze

    attr_accessor :profile, :root_url, :auth_token, :extension, :compile_id,
                  :download_folder

    def initialize
      self.profile = :default
      self.extension = 'yaml'
    end

    def file_extension
      FILE_EXTENSION_TYPES[extension]
    end

    def check!
      raise InvalidExtension unless EXTENSION_TYPES.include?(extension)
    end
  end
end
