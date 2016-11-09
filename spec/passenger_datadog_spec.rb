# frozen_string_literal: true
require 'spec_helper'

describe PassengerDatadog do
  let(:Statsd) { double(Statsd) }
  let(:statsd) { instance_double(Statsd) }

  context 'passenger not running' do
    before do
      allow(described_class).to receive(:`).and_return('')
    end

    it 'does not send stats to datadog' do
      expect(Statsd).not_to receive(:new)

      described_class.run
    end
  end

  context 'passenger 4' do
    before do
      allow(described_class).to receive(:`).and_return(File.read('spec/fixtures/passenger_4_status.xml'))
    end

    let(:passenger_status) do
      [['passenger.pool.used', '5'],
       ['passenger.pool.max', '20'],
       ['passenger.request_queue', '0'],
       ['passenger.enabled_process_count', '5'],
       ['passenger.disabling_process_count', '0'],
       ['passenger.disabled_process_count', '0'],

       ['passenger.processed', '149', { :tags => ['passenger-process:0'] }],
       ['passenger.sessions', '0', { :tags => ['passenger-process:0'] }],
       ['passenger.concurrency', '1', { :tags => ['passenger-process:0'] }],
       ['passenger.cpu', '0', { :tags => ['passenger-process:0'] }],
       ['passenger.rss', '554312', { :tags => ['passenger-process:0'] }],
       ['passenger.private_dirty', '548660', { :tags => ['passenger-process:0'] }],
       ['passenger.pss', '549560', { :tags => ['passenger-process:0'] }],
       ['passenger.swap', '0', { :tags => ['passenger-process:0'] }],
       ['passenger.real_memory', '548660', { :tags => ['passenger-process:0'] }],
       ['passenger.vmsize', '952668', { :tags => ['passenger-process:0'] }],

       ['passenger.processed', '273', { :tags => ['passenger-process:1'] }],
       ['passenger.sessions', '0', { :tags => ['passenger-process:1'] }],
       ['passenger.concurrency', '1', { :tags => ['passenger-process:1'] }],
       ['passenger.cpu', '0', { :tags => ['passenger-process:1'] }],
       ['passenger.rss', '547088', { :tags => ['passenger-process:1'] }],
       ['passenger.private_dirty', '541420', { :tags => ['passenger-process:1'] }],
       ['passenger.pss', '542326', { :tags => ['passenger-process:1'] }],
       ['passenger.swap', '0', { :tags => ['passenger-process:1'] }],
       ['passenger.real_memory', '541420', { :tags => ['passenger-process:1'] }],
       ['passenger.vmsize', '963948', { :tags => ['passenger-process:1'] }],

       ['passenger.processed', '139', { :tags => ['passenger-process:2'] }],
       ['passenger.sessions', '0', { :tags => ['passenger-process:2'] }],
       ['passenger.concurrency', '1', { :tags => ['passenger-process:2'] }],
       ['passenger.cpu', '0', { :tags => ['passenger-process:2'] }],
       ['passenger.rss', '533704', { :tags => ['passenger-process:2'] }],
       ['passenger.private_dirty', '258196', { :tags => ['passenger-process:2'] }],
       ['passenger.pss', '394044', { :tags => ['passenger-process:2'] }],
       ['passenger.swap', '0', { :tags => ['passenger-process:2'] }],
       ['passenger.real_memory', '258196', { :tags => ['passenger-process:2'] }],
       ['passenger.vmsize', '887132', { :tags => ['passenger-process:2'] }],

       ['passenger.processed', '135', { :tags => ['passenger-process:3'] }],
       ['passenger.sessions', '0', { :tags => ['passenger-process:3'] }],
       ['passenger.concurrency', '1', { :tags => ['passenger-process:3'] }],
       ['passenger.cpu', '1', { :tags => ['passenger-process:3'] }],
       ['passenger.rss', '559972', { :tags => ['passenger-process:3'] }],
       ['passenger.private_dirty', '284396', { :tags => ['passenger-process:3'] }],
       ['passenger.pss', '420259', { :tags => ['passenger-process:3'] }],
       ['passenger.swap', '0', { :tags => ['passenger-process:3'] }],
       ['passenger.real_memory', '284396', { :tags => ['passenger-process:3'] }],
       ['passenger.vmsize', '915564', { :tags => ['passenger-process:3'] }],

       ['passenger.processed', '236', { :tags => ['passenger-process:4'] }],
       ['passenger.sessions', '0', { :tags => ['passenger-process:4'] }],
       ['passenger.concurrency', '1', { :tags => ['passenger-process:4'] }],
       ['passenger.cpu', '0', { :tags => ['passenger-process:4'] }],
       ['passenger.rss', '548696', { :tags => ['passenger-process:4'] }],
       ['passenger.private_dirty', '543068', { :tags => ['passenger-process:4'] }],
       ['passenger.pss', '543957', { :tags => ['passenger-process:4'] }],
       ['passenger.swap', '0', { :tags => ['passenger-process:4'] }],
       ['passenger.real_memory', '543068', { :tags => ['passenger-process:4'] }],
       ['passenger.vmsize', '964668', { :tags => ['passenger-process:4'] }]]
    end

    it 'sends stats to datadog' do
      allow(Statsd).to receive(:new).and_return(statsd)
      allow(statsd).to receive(:batch).and_yield(statsd)

      expect(statsd).not_to receive(:gauge).with('passenger.busyness', anything)
      expect(statsd).not_to receive(:gauge).with('passenger.capacity_used', anything)
      expect(statsd).not_to receive(:gauge).with('passenger.processes_being_spawned', anything)

      passenger_status.each do |key, *value|
        expect(statsd).to receive(:gauge).with(key, *value)
      end

      described_class.run
    end
  end

  context 'passenger 5' do
    before do
      allow(described_class).to receive(:`).and_return(File.read('spec/fixtures/passenger_5_status.xml'))
    end

    let(:passenger_status) do
      [['passenger.pool.used', '2'],
       ['passenger.pool.max', '5'],
       ['passenger.request_queue', '0'],
       ['passenger.capacity_used', '2'],
       ['passenger.processes_being_spawned', '0'],
       ['passenger.enabled_process_count', '2'],
       ['passenger.disabling_process_count', '0'],
       ['passenger.disabled_process_count', '0'],

       ['passenger.processed', '2', { :tags => ['passenger-process:0'] }],
       ['passenger.sessions', '0', { :tags => ['passenger-process:0'] }],
       ['passenger.busyness', '0', { :tags => ['passenger-process:0'] }],
       ['passenger.concurrency', '1', { :tags => ['passenger-process:0'] }],
       ['passenger.cpu', '0', { :tags => ['passenger-process:0'] }],
       ['passenger.rss', '409596', { :tags => ['passenger-process:0'] }],
       ['passenger.private_dirty', '126456', { :tags => ['passenger-process:0'] }],
       ['passenger.pss', '267231', { :tags => ['passenger-process:0'] }],
       ['passenger.swap', '0', { :tags => ['passenger-process:0'] }],
       ['passenger.real_memory', '126456', { :tags => ['passenger-process:0'] }],
       ['passenger.vmsize', '812632', { :tags => ['passenger-process:0'] }],

       ['passenger.processed', '3', { :tags => ['passenger-process:1'] }],
       ['passenger.sessions', '0', { :tags => ['passenger-process:1'] }],
       ['passenger.busyness', '0', { :tags => ['passenger-process:1'] }],
       ['passenger.concurrency', '1', { :tags => ['passenger-process:1'] }],
       ['passenger.cpu', '0', { :tags => ['passenger-process:1'] }],
       ['passenger.rss', '407972', { :tags => ['passenger-process:1'] }],
       ['passenger.private_dirty', '124832', { :tags => ['passenger-process:1'] }],
       ['passenger.pss', '265607', { :tags => ['passenger-process:1'] }],
       ['passenger.swap', '0', { :tags => ['passenger-process:1'] }],
       ['passenger.real_memory', '124832', { :tags => ['passenger-process:1'] }],
       ['passenger.vmsize', '812536', { :tags => ['passenger-process:1'] }]]
    end

    it 'sends stats to datadog' do
      allow(Statsd).to receive(:new).and_return(statsd)
      allow(statsd).to receive(:batch).and_yield(statsd)

      passenger_status.each do |key, *value|
        expect(statsd).to receive(:gauge).with(key, *value)
      end

      described_class.run
    end
  end

  context 'passenger 5 tom' do
    before do
      allow(described_class).to receive(:`).and_return(File.read('spec/fixtures/passenger_5_status.xml'))
    end
    
    let(:metrics) do
      [
        ['passenger.pool.used', '2'],
        ['passenger.pool.max', '5'], 
        ['passenger.request_queue', '0'],
        ['passenger.capacity_used', '2'],
        ['passenger.processes_being_spawned', '0'],
        ['passenger.enabled_process_count', '2'],
        ['passenger.disabling_process_count', '0'],
        ['passenger.disabled_process_count', '0'],

        ['passenger.processed', '2', { :tags => ['passenger-process:0'] }],
        ['passenger.sessions', '0', { :tags => ['passenger-process:0'] }],
        ['passenger.busyness', '0', { :tags => ['passenger-process:0'] }],
        ['passenger.concurrency', '1', { :tags => ['passenger-process:0'] }],
        ['passenger.cpu', '0', { :tags => ['passenger-process:0'] }],
        ['passenger.rss', '409596', { :tags => ['passenger-process:0'] }],
        ['passenger.private_dirty', '126456', { :tags => ['passenger-process:0'] }],
        ['passenger.pss', '267231', { :tags => ['passenger-process:0'] }],
        ['passenger.swap', '0', { :tags => ['passenger-process:0'] }],
        ['passenger.real_memory', '126456', { :tags => ['passenger-process:0'] }],
        ['passenger.vmsize', '812632', { :tags => ['passenger-process:0'] }],

        ['passenger.processed', '3', { :tags => ['passenger-process:1'] }],
        ['passenger.sessions', '0', { :tags => ['passenger-process:1'] }],
        ['passenger.busyness', '0', { :tags => ['passenger-process:1'] }],
        ['passenger.concurrency', '1', { :tags => ['passenger-process:1'] }],
        ['passenger.cpu', '0', { :tags => ['passenger-process:1'] }],
        ['passenger.rss', '407972', { :tags => ['passenger-process:1'] }],
        ['passenger.private_dirty', '124832', { :tags => ['passenger-process:1'] }],
        ['passenger.pss', '265607', { :tags => ['passenger-process:1'] }],
        ['passenger.swap', '0', { :tags => ['passenger-process:1'] }],
        ['passenger.real_memory', '124832', { :tags => ['passenger-process:1'] }],
        ['passenger.vmsize', '812536', { :tags => ['passenger-process:1'] }]
      ]
    end

    it 'parses passenger status' do
      expect(described_class.parse(File.read('spec/fixtures/passenger_5_status.xml'))).to eq(metrics)
    end
  end
end
