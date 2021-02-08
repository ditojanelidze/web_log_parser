# frozen_string_literal: true

module WebLogParser
  module Lib
    # Log File Parser
    class Parser
      attr_reader :options, :storage

      def initialize(options, storage)
        @options = options
        @storage = storage
      end

      def parse
      end
    end
  end
end
