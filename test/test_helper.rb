# frozen_string_literal: true

# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 license (see LICENSE).
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2020 Datadog, Inc.

require 'simplecov'
SimpleCov.start

require 'opentelemetry-exporters-datadog'
require 'opentelemetry-sdk'
require 'opentelemetry-api'
require 'minitest/autorun'
require 'ddtrace/contrib/redis/ext'

OpenTelemetry.logger = Logger.new('/dev/null')
