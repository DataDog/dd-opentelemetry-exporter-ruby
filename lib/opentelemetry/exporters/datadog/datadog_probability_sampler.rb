# frozen_string_literal: true

# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 license (see LICENSE).
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2020 Datadog, Inc.

module OpenTelemetry
  module Exporters
    module Datadog
      # Implements sampling based on a probability but records all spans regardless.
      class DatadogProbabilitySampler
        attr_reader :description

        RECORD_AND_SAMPLE = Datadog::Result.new(decision: Datadog::Decision::RECORD_AND_SAMPLE)
        RECORD_ONLY = Datadog::Result.new(decision: Datadog::Decision::RECORD_ONLY)

        private_constant(:RECORD_AND_SAMPLE, :RECORD_ONLY)

        def initialize(probability)
          @probability = probability
          @id_upper_bound = (probability * (2**64 - 1)).ceil
          @description = format('TraceIdRatioBased{%.6f}', probability)
        end

        def sample?(trace_id)
          @probability == 1.0 || trace_id[8, 8].unpack1('Q>') < @id_upper_bound
        end

        # @api private
        #
        # See {Samplers}.
        def should_sample?(trace_id:, parent_context:, links:, name:, kind:, attributes:)
          # Ignored for sampling decision: links, name, kind, attributes.

          if sample?(trace_id)
            RECORD_AND_SAMPLE
          else
            RECORD_ONLY
          end
        end

        # Returns a new sampler. The probability of sampling a trace is equal
        # to that of the specified probability.
        #
        # @param [Numeric] probability The desired probability of sampling.
        #   Must be within [0.0, 1.0].
        def self.default_with_probability(probability = 1.0)
          raise ArgumentError, 'probability must be in range [0.0, 1.0]' unless (0.0..1.0).include?(probability)

          new(probability)
        end

        DEFAULT = new(1.0)
      end
    end
  end
end
