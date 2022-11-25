# frozen_string_literal: true

require 'rails_helper'

describe ServiceProviders::Acme::HotelDataMapper do
  let(:raw_data) do
    {
      "Id": 'iJhz',
      "DestinationId": 5432,
      "Name": 'Beach Villas Singapore',
      "Latitude": 1.264751,
      "Longitude": 103.824006,
      "Address": ' 8 Sentosa Gateway, Beach Villas ',
      "City": 'Singapore',
      "Country": 'SG',
      "PostalCode": '098269',
      "Description": '  This 5 star hotel is located on the coastline of Singapore.',
      "Facilities": [
        'Pool',
        'BusinessCenter',
        'WiFi ',
        'DryCleaning',
        ' Breakfast'
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
        latitude: 1.264751,
        longitude: 103.824006,
        address: '8 Sentosa Gateway, Beach Villas',
        city: 'Singapore',
        postal_code: '098269',
        country: 'Singapore',
        description: 'This 5 star hotel is located on the coastline of Singapore.',
        amenities: [
          'Pool',
          'BusinessCenter',
          'WiFi',
          'DryCleaning',
          'Breakfast'
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
