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
          set_path_type
          set_file_name
        end

        private

        def set_path_type
          option = args[0]
          case option&.downcase
          when '-f', '--full'
            @options[:type] = :full
          when '-r', '--relative'
            @options[:type] = :relative
          when nil, ''
            raise Errors::NoArguments
          else
            raise Errors::UnknownOption, option
          end
        end

        def set_file_name
          file_arg = args[1]
          raise Errors::ParameterRequired if file_arg.nil?

          file_path = @options[:type] == :full ? file_arg : Dir.pwd.concat('/', file_arg)
          raise Errors::FileNotFound, file_path unless File.exist? file_path

          @options[:file] = file_path
        end
      end
    end

    module Errors
      # General Command Line Error
      class CommandLineError < StandardError; end

      # Unknown Option Error
      class UnknownOption < CommandLineError
        def initialize(opt)
          super("Unknown option (#{opt}) passed")
        end
      end

      # Parameter Required Error
      class ParameterRequired < CommandLineError
        def initialize
          super('File parameter is required')
        end
      end

      # File Not Found Error
      class FileNotFound < CommandLineError
        def initialize(path)
          super("File (#{path}) doesn't exits")
        end
      end

      # No Arguments Error
      class NoArguments < CommandLineError
        def initialize
          super('Please provide parameters')
        end
      end
    end
  end
end
