# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelFinder do
  let(:hotels) do
    3.times.map do |idx|
      FactoryBot.create :hotel, destination_id: idx
    end
  end

  before do
    hotels
  end

  context 'when no destination id nor hotel id is passed' do
    it 'returns all hotels' do
      expect(described_class.call).to eq Hotel.all
    end
  end

  context 'when destination_id is passed' do
    it 'returns all hotels that match the destination_id' do
      expect(described_class.call(destination_id: 0)).to eq [hotels.first]
    end
  end

  context 'when hotel_ids are passed' do
    it 'returns all hotels that match the hotel_ids' do
      filter_value = hotels.map(&:identifier)[0..1]
      expect(described_class.call(hotel_ids: filter_value)).to eq hotels[0..1]
    end
  end
end
