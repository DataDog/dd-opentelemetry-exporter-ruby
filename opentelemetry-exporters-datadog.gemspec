# frozen_string_literal: true

# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 license (see LICENSE).
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2020 Datadog, Inc.

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'opentelemetry-exporters-datadog/exporters/datadog/version'
require 'opentelemetry/exporters/datadog/version'

Gem::Specification.new do |spec|
  spec.name        = 'opentelemetry-exporters-datadog'
  spec.version     = OpenTelemetry::Exporters::Datadog::VERSION
  spec.authors     = ['Datadog, Inc.']
  spec.email       = ['dev@datadoghq.com']

  spec.summary     = 'Datadog trace exporter for the OpenTelemetry framework'
  spec.description = <<-DESC.gsub(/^[\s]+/, '')
    opentelemetry-exporters-datadog is Datadog’s trace exporter for the OpenTelemetry
    Ruby tracing library, which  is used to trace requests across web servers, databases
    and microservices. The exporter formats and sends these traces to a Datadog Agent so
    that they can be ingested, stored, and analyzed with Datadog.
  DESC

  spec.homepage    = 'https://github.com/Datadog/dd-opentelemetry-exporter-ruby'
  spec.license     = 'Apache-2.0'

  spec.files = ::Dir.glob('lib/**/*.rb') +
               ::Dir.glob('*.md') +
               ['LICENSE', '.yardopts']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency 'ddtrace', '~> 0.37'
  spec.add_dependency 'opentelemetry-api', '~> 0.5'
  spec.add_dependency 'opentelemetry-sdk', '~> 0.5'

  spec.add_development_dependency 'bundler', '>= 1.17'
  spec.add_development_dependency 'faraday', '~> 0.13'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rubocop', '~> 0.73.0'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'yard-doctest', '~> 0.1.6'
end
