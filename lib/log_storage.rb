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
        new_log = ActivityLog.new(path, ip)
        current_log_data = @logs_data[new_log.path]
        current_log_data ? update_record(current_log_data, new_log) : create_new_record(new_log)
      end

      def top_unique_visitors
        data_view.sort { |page1, page2| page2[:unique_visitors] <=> page1[:unique_visitors] }
      end

      def top_views
        data_view.sort { |page1, page2| page2[:views] <=> page1[:views] }
      end

      private

      def update_record(current_log_data, new_log)
        current_log_data.ips << new_log.ip
        current_log_data.requests_count += 1
      end

      def create_new_record(new_log)
        @logs_data[new_log.path] = PathInfo.new(Set.new([new_log.ip]), 1)
      end

      def data_view
        @logs_data.map do |path, data|
          { path: path, unique_visitors: data.ips.count, views: data.requests_count }
        end
      end

      # Activity Log Entry Data Holding Struct
      ActivityLog = Struct.new(:path, :ip)

      # Path Collected Data Holding Struct
      PathInfo = Struct.new(:ips, :requests_count)
    end
  end
end
