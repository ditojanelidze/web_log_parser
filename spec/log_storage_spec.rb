# frozen_string_literal: true

require_relative '../lib/log_storage'
require 'faker'

RSpec.describe WebLogParser::Lib::LogStorage do
  it 'should save new entry' do
    storage = WebLogParser::Lib::LogStorage.new
    storage.push '/home', Faker::Internet.ip_v4_address
    expect(storage.instance_variable_get(:@logs_data).count).to eq 1
  end

  it 'should save random amount of entries' do
    storage = WebLogParser::Lib::LogStorage.new
    n = rand(20)
    n.times { storage.push '/home', Faker::Internet.ip_v4_address }
    logs_data = storage.instance_variable_get(:@logs_data)
    expect(logs_data.count).to eq 1
    expect(logs_data['/home'].ips.count).to eq n
    expect(logs_data['/home'].requests_count).to eq n
  end

  it 'should save new entry' do
    storage = WebLogParser::Lib::LogStorage.new
    storage.push '/home', Faker::Internet.ip_v4_address
    storage.push '/about', Faker::Internet.ip_v4_address
    expect(storage.instance_variable_get(:@logs_data).count).to eq 2
  end

  it 'should get list ordered by requests' do
    storage = WebLogParser::Lib::LogStorage.new
    5.times { storage.push '/home', Faker::Internet.ip_v4_address }
    3.times { storage.push '/about', Faker::Internet.ip_v4_address }
    8.times { storage.push '/list', Faker::Internet.ip_v4_address }

    list = storage.top_views

    expect(list[0][:path]).to eq '/list'
    expect(list[1][:path]).to eq '/home'
    expect(list[2][:path]).to eq '/about'
  end

  it 'should get list ordered by requests' do
    storage = WebLogParser::Lib::LogStorage.new
    ip_1 = Faker::Internet.ip_v4_address
    ip_2 = Faker::Internet.ip_v4_address
    ip_3 = Faker::Internet.ip_v4_address
    storage.push '/home', ip_1
    storage.push '/home', ip_2

    storage.push '/about', ip_1
    storage.push '/about', ip_2
    storage.push '/about', ip_3

    storage.push '/list', ip_2

    list = storage.top_unique_visitors

    expect(list[0][:path]).to eq '/about'
    expect(list[1][:path]).to eq '/home'
    expect(list[2][:path]).to eq '/list'
  end
end
