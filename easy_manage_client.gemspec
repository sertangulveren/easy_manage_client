# frozen_string_literal: true

require_relative 'lib/easy_manage_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'easy_manage_client'
  spec.version       = EasyManageClient::VERSION
  spec.authors       = ['Sertan Gülveren', 'Yiğit Sadıç']
  spec.email         = ['sertangulveren@gmail.com', 'yigitsadic@gmail.com']

  spec.summary       = 'EasyManage API client for ruby.'
  spec.description   = 'It is a simple ruby client for EasyManage API.'
  spec.homepage      = 'https://github.com/sertangulveren'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency('byebug')
  spec.add_development_dependency('dotenv', '~> 2.7')
  spec.add_development_dependency('minitest', '~> 5.0')
  spec.add_development_dependency('rake', '~> 12.0')
  spec.add_development_dependency('rubocop', '~> 0.79.0')
  spec.add_development_dependency('simplecov', '~> 0.17.1')
  spec.add_development_dependency('webmock', '~> 3.8')

  spec.add_dependency('faraday', '~> 0.11.0')
end
