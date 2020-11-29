# frozen_string_literal: true

# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 license (see LICENSE).
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2020 Datadog, Inc.

module OpenTelemetry
  module Exporters
    module Datadog
      # The Decision module contains a set of constants to be used in the
      # decision part of a sampling {Result}.
      module Decision
        # Decision to not record events and not sample.
        DROP = :__drop__

        # Decision to record events and not sample.
        RECORD_ONLY = :__record_only__

        # Decision to record events and sample.
        RECORD_AND_SAMPLE = :__record_and_sample__
      end
    end
  end
end