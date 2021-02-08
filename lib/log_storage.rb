# frozen_string_literal: true

require 'set'

module WebLogParser
  module Lib
    # Parsed Logs Storage
    class LogStorage
      def initialize
        @logs_data = {}
      end

      def push(path, ip)
      end

      def top_unique_visitors
        []
      end

      def top_views
        []
      end
    end
  end
end
