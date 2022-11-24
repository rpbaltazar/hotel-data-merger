# frozen_string_literal: true

require 'rails_helper'

describe ServiceProviders::DataFetcherRegistry do
  let(:acme_hotels) do
    [
      FactoryBot.build(:hotel, identifier: 'aaaa'),
      FactoryBot.build(:hotel, identifier: 'bbbb')
    ]
  end

  let(:patagonia_hotels) do
    [
      FactoryBot.build(:hotel, identifier: 'aaaa', description: 'amazing hotel in patagonia'),
      FactoryBot.build(:hotel, identifier: 'cccc', city: 'Kuala Lumpur')
    ]
  end

  let(:paperflies_hotels) do
    [
      FactoryBot.build(:hotel, identifier: 'aaaa', description: 'amazing hotel in patagonia, middle of the ocean'),
      FactoryBot.build(:hotel, identifier: 'bbbb', city: 'Singapore'),
      FactoryBot.build(:hotel, identifier: 'cccc', country: 'Malaysia')
    ]
  end

  before do
    allow(ServiceProviders::Acme::DataFetcher).to receive(:call).and_return(acme_hotels)
    allow(ServiceProviders::Paperflies::DataFetcher).to receive(:call).and_return(paperflies_hotels)
    allow(ServiceProviders::Patagonia::DataFetcher).to receive(:call).and_return(patagonia_hotels)
  end

  describe 'self.fetch_all' do
    it 'returns final list of hotels with merged data' do
      result = described_class.fetch_all
      expected_results = [
        FactoryBot.build(:hotel, identifier: 'aaaa', description: 'amazing hotel in patagonia, middle of the ocean'),
        FactoryBot.build(:hotel, identifier: 'bbbb', city: 'Singapore'),
        FactoryBot.build(:hotel, identifier: 'cccc', city: 'Kuala Lumpur', country: 'Malaysia')
      ]

      # NOTE: Quick way to compare the objects
      # TODO: We should have a matcher to compare two hotels
      serialized_result = HotelBlueprint.render(result)
      serialized_expected = HotelBlueprint.render(expected_results)
      expect(serialized_result).to eq serialized_expected
    end
  end
end
