# frozen_string_literal: true

module WebLogParser
  module Cli
    module Option
      # Command Line Parameters Handler
      class Parser
        attr_reader :args, :options

        def initialize(args)
          @args = args
          @options = {}
        end

        def parse
        end
      end
    end

    module Errors
      # General Command Line Error
      class CommandLineError < StandardError; end
    end
  end
end
