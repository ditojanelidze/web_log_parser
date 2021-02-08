# frozen_string_literal: true
require 'ipaddress'
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
        line_number = 0
        file.each do |line|
          line_number += 1
          record_data = line.chomp.split(' ')
          next unless valid_line?(record_data, line_number)

          path, ip = record_data
          @storage.push path, ip
        end
      rescue StandardError => e
        puts "Error while reading file - #{e.message}"
        puts "Error backtrace - #{e.backtrace&.join("\n")}" if e.backtrace
      ensure
        file.close
      end

      def valid_line?(record_data, line_number)
        if record_data.length < 2 || !IPAddress.valid?(record_data[1])
          puts "Warning! Can not read line data on line - #{line_number}"
          return false
        end
        true
      end
    end
  end
end
