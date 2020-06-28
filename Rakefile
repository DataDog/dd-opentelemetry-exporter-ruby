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
  t.libs << '../../api/lib'
  t.libs << '../../sdk/lib'
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
