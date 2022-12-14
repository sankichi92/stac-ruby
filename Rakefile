# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rdoc/task'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

task default: %i[spec rubocop]

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'stac-ruby API docs'
  rdoc.rdoc_files.include('README.md', 'CHANGELOG.md', 'GETTING_STARTED.md', 'lib/**/*.rb')
  rdoc.main = 'README.md'
end

namespace :fixture do
  desc 'Setup spec/fixtures'
  task setup: %w[
    spec/fixtures/stac-spec
    spec/fixtures/eo/item.json
    spec/fixtures/projection/item.json
    spec/fixtures/scientific/item.json
    spec/fixtures/scientific/collection.json
    spec/fixtures/scientific/collection-assets.json
    spec/fixtures/view/item.json
  ]

  desc 'Remove spec/fixtures'
  task :clean do
    rm_r 'spec/fixtures'
  end

  directory 'spec/fixtures/stac-spec'

  file 'spec/fixtures/stac-spec' do |t|
    cp_r 'stac-spec/examples/.', t.name
  end

  directory 'spec/fixtures/eo'

  file 'spec/fixtures/eo/item.json' => 'spec/fixtures/eo' do |t|
    sh "curl https://raw.githubusercontent.com/stac-extensions/eo/v1.0.0/examples/item.json -o #{t.name} -sS"
  end

  directory 'spec/fixtures/projection'

  file 'spec/fixtures/projection/item.json' => 'spec/fixtures/projection' do |t|
    sh "curl https://raw.githubusercontent.com/stac-extensions/projection/v1.0.0/examples/item.json -o #{t.name} -sS"
  end

  directory 'spec/fixtures/scientific'

  file 'spec/fixtures/scientific/item.json' => 'spec/fixtures/scientific' do |t|
    sh "curl https://raw.githubusercontent.com/stac-extensions/scientific/v1.0.0/examples/item.json -o #{t.name} -sS"
  end

  file 'spec/fixtures/scientific/collection.json' => 'spec/fixtures/scientific' do |t|
    sh 'curl https://raw.githubusercontent.com/stac-extensions/scientific/v1.0.0/examples/collection.json ' \
       "-o #{t.name} -sS"
  end

  file 'spec/fixtures/scientific/collection-assets.json' => 'spec/fixtures/scientific' do |t|
    sh 'curl https://raw.githubusercontent.com/stac-extensions/scientific/v1.0.0/examples/collection-assets.json ' \
       "-o #{t.name} -sS"
  end

  directory 'spec/fixtures/view'

  file 'spec/fixtures/view/item.json' => 'spec/fixtures/view' do |t|
    sh "curl https://raw.githubusercontent.com/stac-extensions/view/v1.0.0/examples/item.json -o #{t.name} -sS"
  end
end
