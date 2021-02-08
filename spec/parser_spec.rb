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

      allow(File).to receive(:exist?).and_return true
      allow(File).to receive(:open).and_return ["/some_url #{Faker::Internet.ip_v4_address}"]
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

      allow(File).to receive(:exist?).and_return true
      allow(File).to receive(:open).and_raise StandardError
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
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

      allow(File).to receive(:exist?).and_return true
      allow(File).to receive(:open).and_return ["/some_url #{Faker::Internet.ip_v4_address}"]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      cli_parser.parse

      storage = WebLogParser::Lib::LogStorage.new
      allow(storage).to receive(:push).and_raise StandardError
      file_parser = WebLogParser::Lib::Parser.new(cli_parser.options, storage)
      file_parser.parse

      expect(storage.instance_variable_get(:@logs_data).empty?).to be true
    end
  end

  context 'line validation' do
    it 'validate line data' do
      file_parser = WebLogParser::Lib::Parser.new(nil, nil)
      expect(file_parser.send(:valid_line?, ["/some/rul", Faker::Internet.ip_v4_address], 1)).to eq true
    end

    it 'validate line data' do
      file_parser = WebLogParser::Lib::Parser.new(nil, nil)
      expect(file_parser.send(:valid_line?, ["/some/rul", Faker::Internet.ip_v6_address], 1)).to eq true
    end

    it 'validate line data' do
      file_parser = WebLogParser::Lib::Parser.new(nil, nil)
      expect(file_parser.send(:valid_line?, ["/some/rul", Faker::Quote.famous_last_words], 1)).to eq false
    end

    it 'validate line data' do
      file_parser = WebLogParser::Lib::Parser.new(nil, nil)
      expect(file_parser.send(:valid_line?, ["/some/rul"], 1)).to eq false
    end
  end
end
