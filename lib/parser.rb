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
        file = File.open(@options[:file], 'r')
        read_file(file)
      rescue StandardError => e
        puts "Error while opening file - #{e.message}"
        puts "Error backtrace - #{e.backtrace&.join("\n")}" if e.backtrace
      end

      private

      def read_file(file)
        file.each do |line|
          record_data = line.chomp.split(' ')
          path, ip = record_data
          @storage.push path, ip
        end
      rescue StandardError => e
        puts "Error while reading file - #{e.message}"
        puts "Error backtrace - #{e.backtrace&.join("\n")}" if e.backtrace
      ensure
        file.close
      end
    end
  end
end
