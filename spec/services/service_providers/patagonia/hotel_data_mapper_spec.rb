# frozen_string_literal: true

require 'rails_helper'

describe ServiceProviders::Patagonia::HotelDataMapper do
  let(:raw_data) do
    {
      "id": 'iJhz',
      "destination": 5432,
      "name": 'Beach Villas Singapore',
      "lat": 1.264751,
      "lng": 103.824006,
      "address": '8 Sentosa Gateway, Beach Villas, 098269',
      "info": ' Located at the western tip of Resorts World Sentosa  ',
      "amenities": [
        'Aircon',
        'Tv',
        'Coffee machine'
      ],
      "images": {
        "rooms": [
          {
            "url": 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
            "description": 'Double room'
          }
        ],
        "amenities": [
          {
            "url": 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg',
            "description": 'RWS'
          }
        ]
      }
    }
  end

  describe 'hotel_model' do
    it 'returns a hotel model from the attributes' do
      hotel_model = described_class.new(raw_data.as_json).hotel_model
      expect(hotel_model).to have_attributes(
        identifier: 'iJhz',
        destination_id: 5432,
        name: 'Beach Villas Singapore',
        latitude: 1.264751,
        longitude: 103.824006,
        address: '8 Sentosa Gateway, Beach Villas, 098269',
        description: 'Located at the western tip of Resorts World Sentosa',
        amenities: [
          'Aircon',
          'Tv',
          'Coffee machine'
        ]
      )
    end
  end

  describe 'self.from_array' do
    it 'returns an array of hotels' do
      data = 2.times.map { raw_data }.as_json
      hotels = described_class.from_array(hotels_data: data)
      expect(hotels[0].class).to eq ::HotelRawDatum
      expect(hotels.map(&:identifier)).to match_array %w[iJhz iJhz]
    end
  end
end
