# frozen_string_literal: true

# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 license (see LICENSE).
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2020 Datadog, Inc.

module OpenTelemetry
  module Exporters
    module Datadog
      # The Result class represents an arbitrary sampling result. It has
      # boolean values for the sampling decision and whether to record
      # events, and a collection of attributes to be attached to a sampled
      # root span.
      class Result
        EMPTY_HASH = {}.freeze
        DECISIONS = [Datadog::Decision::RECORD_ONLY, Datadog::Decision::DROP, Datadog::Decision::RECORD_AND_SAMPLE].freeze
        private_constant(:EMPTY_HASH, :DECISIONS)

        # Returns a frozen hash of attributes to be attached span.
        #
        # @return [Hash{String => String, Numeric, Boolean, Array<String, Numeric, Boolean>}]
        attr_reader :attributes

        # Returns a new sampling result with the specified decision and
        # attributes.
        #
        # @param [Symbol] decision Whether or not a span should be sampled
        #   and/or record events.
        # @param [optional Hash{String => String, Numeric, Boolean, Array<String, Numeric, Boolean>}]
        #   attributes A frozen or freezable hash containing attributes to be
        #   attached to the span.
        def initialize(decision:, attributes: nil)
          @decision = decision
          @attributes = attributes.freeze || EMPTY_HASH
        end

        # Returns true if this span should be sampled.
        #
        # @return [Boolean] sampling decision
        def sampled?
          @decision == Datadog::Decision::RECORD_AND_SAMPLE
        end

        # Returns true if this span should record events, attributes, status, etc.
        #
        # @return [Boolean] recording decision
        def recording?
          @decision != Datadog::Decision::DROP
        end
      end
    end
  end
end