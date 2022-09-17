# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'steep'
require 'steep/cli'
namespace :steep do
  desc 'Run steep check'
  task :check do
    exit Steep::CLI.new(argv: %w[check], stdout: $stdout, stderr: $stderr, stdin: $stdin).run
  end
end

task default: %i[spec rubocop steep:check]

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'stac-ruby API docs'
  rdoc.rdoc_files.include('README.md', 'CHANGELOG.md', 'lib/**/*.rb')
  rdoc.main = 'README.md'
end
