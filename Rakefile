# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

import('lib/tasks/easy_manage_client.rake')

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
end

task default: :test

RuboCop::RakeTask.new

task default: %i[test rubocop]
