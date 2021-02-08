# frozen_string_literal: true

require_relative '../lib/parser'
require_relative '../lib/log_storage'
require_relative '../cli/command_line'
require 'faker'

RSpec.describe WebLogParser::Lib::Parser do
  context 'with successfully running arguments' do
    it 'should return valid options object with -f option' do
      file_path= Faker::File.file_name
      options = %w[-f --full -r --relative]
      args = [options.sample, file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      cli_parser.parse
      storage = WebLogParser::Lib::LogStorage.new
      file_parser = WebLogParser::Lib::Parser.new(cli_parser.options, storage)
      file_parser.parse
      expect(storage.instance_variable_get(:@logs_data).empty?).to be false
    end
  end

  context 'with unsuccessfully running arguments' do
    it 'should raise file open error' do
      file_path= Faker::File.file_name
      options = %w[-f --full -r --relative]
      args = [options.sample, file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      allow(File).to receive(:open).and_raise StandardError
      cli_parser.parse
      storage = WebLogParser::Lib::LogStorage.new
      file_parser = WebLogParser::Lib::Parser.new(cli_parser.options, storage)
      file_parser.parse
      expect(storage.instance_variable_get(:@logs_data).empty?).to be true
    end

    it 'raises error while writing parsed data to storage' do
      file_path= Faker::File.file_name
      options = %w[-f --full -r --relative]
      args = [options.sample, file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      allow(File).to receive(:exist?).and_return true
      cli_parser.parse
      storage = WebLogParser::Lib::LogStorage.new
      allow(storage).to receive(:push).and_raise StandardError
      file_parser = WebLogParser::Lib::Parser.new(cli_parser.options, storage)
      file_parser.parse
      expect(storage.instance_variable_get(:@logs_data).empty?).to be true
    end
  end
end