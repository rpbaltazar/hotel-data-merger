# frozen_string_literal: true

require 'rails_helper'

describe ServiceProviders::Paperflies::HotelDataMapper do
  let(:raw_data) do
    {
      "hotel_id": 'iJhz',
      "destination_id": 5432,
      "hotel_name": 'Beach Villas Singapore',
      "location": {
        "address": '8 Sentosa Gateway, Beach Villas, 098269',
        "country": 'Singapore'
      },
      "details": 'Surrounded by tropical gardens, these upscale villas in elegant Colonial-style buildings',
      "amenities": {
        "general": [
          'outdoor pool',
          'indoor pool',
          'business center',
          'childcare'
        ],
        "room": [
          'tv',
          'coffee machine',
          'kettle',
          'hair dryer',
          'iron'
        ]
      },
      "images": {
        "rooms": [
          {
            "link": 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
            "caption": 'Double room'
          },
          {
            "link": 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg',
            "caption": 'Double room'
          }
        ],
        "site": [
          {
            "link": 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg',
            "caption": 'Front'
          }
        ]
      },
      "booking_conditions": [
        'Pets are not allowed.',
        'WiFi is available in all areas and is free of charge.'
      ]
    }
  end

  describe 'hotel_model' do
    it 'returns a hotel model from the attributes' do
      hotel_model = described_class.new(raw_data.as_json).hotel_model
      expect(hotel_model).to have_attributes(
        identifier: 'iJhz',
        destination_id: 5432,
        name: 'Beach Villas Singapore',
        address: '8 Sentosa Gateway, Beach Villas, 098269',
        country: 'Singapore',
        description: 'Surrounded by tropical gardens, these upscale villas in elegant Colonial-style buildings',
        amenities: {
          'general' => [
            'outdoor pool',
            'indoor pool',
            'business center',
            'childcare'
          ],
          'room' => [
            'tv',
            'coffee machine',
            'kettle',
            'hair dryer',
            'iron'
          ]
        },
        booking_conditions: [
          'Pets are not allowed.',
          'WiFi is available in all areas and is free of charge.'
        ],
        images: {
          'rooms' => [
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
              'description' => 'Double room'
            },
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg',
              'description' => 'Double room'
            }
          ],
          'site' => [
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg',
              'description' => 'Front'
            }
          ]
        }
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
