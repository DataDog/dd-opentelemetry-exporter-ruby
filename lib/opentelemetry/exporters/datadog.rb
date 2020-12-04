# frozen_string_literal: true

# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 license (see LICENSE).
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2020 Datadog, Inc.

require 'opentelemetry/exporters/datadog/exporter'
require 'opentelemetry/exporters/datadog/version'
require 'opentelemetry/exporters/datadog/datadog_span_processor'
require 'opentelemetry/exporters/datadog/propagator'
require 'opentelemetry/exporters/datadog/datadog_probability_sampler'

# OpenTelemetry is an open source observability framework, providing a
# general-purpose API, SDK, and related tools required for the instrumentation
# of cloud-native software, frameworks, and libraries.
#
# The OpenTelemetry module provides global accessors for telemetry objects.
# See the documentation for the `opentelemetry-api` gem for details.
module OpenTelemetry
end
