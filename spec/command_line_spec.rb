# frozen_string_literal: true

require_relative '../cli/command_line'
require 'faker'

RSpec.describe WebLogParser::Cli::Option::Parser do
  context 'with successfully running arguments' do
    it 'should return valid options object with -f option' do
      file_path= Faker::File.file_name
      args = ['-f', file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      allow(File).to receive(:exist?).and_return true
      cli_parser.parse
      expect(cli_parser.options[:type]).to eq :full
      expect(cli_parser.options[:file]).to eq file_path
    end

    it 'should return valid options object with --full option' do
      file_path= Faker::File.file_name
      args = ['--full', file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      allow(File).to receive(:exist?).and_return true
      cli_parser.parse
      expect(cli_parser.options[:type]).to eq :full
      expect(cli_parser.options[:file]).to eq file_path
    end

    it 'should return valid options object with -r option' do
      file_path= Faker::File.file_name
      args = ['-r', file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      allow(File).to receive(:exist?).and_return true
      cli_parser.parse
      expect(cli_parser.options[:type]).to eq :relative
      expect(cli_parser.options[:file]).to eq Dir.pwd.concat('/', file_path)
    end

    it 'should return valid options object with --relative option' do
      file_path= Faker::File.file_name
      args = ['--relative', file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      allow(File).to receive(:exist?).and_return true
      cli_parser.parse
      expect(cli_parser.options[:type]).to eq :relative
      expect(cli_parser.options[:file]).to eq Dir.pwd.concat('/', file_path)
    end
  end

  context 'with unsuccessfully running arguments' do
    it 'should raise no arguments error' do
      cli_parser = WebLogParser::Cli::Option::Parser.new([])
      expect { cli_parser.parse }.to raise_error WebLogParser::Cli::Errors::NoArguments
    end

    it 'should raise invalid option error' do
      file_path= Faker::File.file_name
      args = [Faker::String.random(length: rand(5..10)), file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      expect { cli_parser.parse }.to raise_error WebLogParser::Cli::Errors::UnknownOption
    end

    it 'should raise file not found error' do
      file_path= Faker::File.file_name
      options = %w[-f --full -r --relative]
      args = [options.sample, file_path]
      cli_parser = WebLogParser::Cli::Option::Parser.new(args)
      expect { cli_parser.parse }.to raise_error WebLogParser::Cli::Errors::FileNotFound
    end

    it 'should raise file parameter required error' do
      options = %w[-f --full -r --relative]
      cli_parser = WebLogParser::Cli::Option::Parser.new([options.sample])
      expect { cli_parser.parse }.to raise_error WebLogParser::Cli::Errors::ParameterRequired
    end
  end
end