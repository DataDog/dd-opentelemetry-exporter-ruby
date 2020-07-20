# frozen_string_literal: true

# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 license (see LICENSE).
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2020 Datadog, Inc.

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yard'

require 'rubocop/rake_task'
RuboCop::RakeTask.new

Rake::TestTask.new :test do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

YARD::Rake::YardocTask.new do |t|
  t.stats_options = ['--list-undoc']
end

if RUBY_ENGINE == 'truffleruby'
  task default: %i[test]
else
  task default: %i[test rubocop yard]
end

# GEM_INFO = {
#   "opentelemetry-exporters-datadog" => {
#     version_getter: ->() {
#       require './lib/opentelemetry/exporters/datadog/version.rb'
#       OpenTelemetry::Exporters::Datadog::VERSION
#     }
#   }	
# }

# Deploy tasks
S3_BUCKET = 'gems.datadoghq.com'.freeze
S3_DIR = ENV['S3_DIR']

task :'release:gem' do
  raise 'Missing environment variable S3_DIR' if !S3_DIR || S3_DIR.empty?
  # load existing deployed gems
  sh "aws s3 cp --exclude 'docs/*' --recursive s3://#{S3_BUCKET}/#{S3_DIR}/ ./rubygems/"

  # create folders
  sh 'mkdir -p ./gems'
  sh 'mkdir -p ./rubygems/gems'

  # build the gem
  Rake::Task['build'].execute

  # copy the output in the indexed folder
  sh 'cp pkg/*.gem ./rubygems/gems/'

  # generate the gems index
  sh 'gem generate_index -v --no-modern -d ./rubygems'

  # remove all local repository gems to limit files needed to be uploaded
  sh 'rm -f ./rubygems/gems/*'

  # re-add new gems
  sh 'cp pkg/*.gem ./rubygems/gems/'

  # deploy a static gem registry
  sh "aws s3 cp --recursive ./rubygems/ s3://#{S3_BUCKET}/#{S3_DIR}/"
end