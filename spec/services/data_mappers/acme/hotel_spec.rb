# frozen_string_literal: true

require 'rails_helper'

describe DataMappers::Acme::Hotel do
  describe 'hotel_model' do
    it 'returns a hotel model from the attributes' do
      data = {
        "Id": "iJhz",
        "DestinationId": 5432,
        "Name": "Beach Villas Singapore",
        "Latitude": 1.264751,
        "Longitude": 103.824006,
        "Address": " 8 Sentosa Gateway, Beach Villas ",
        "City": "Singapore",
        "Country": "SG",
        "PostalCode": "098269",
        "Description": "  This 5 star hotel is located on the coastline of Singapore.",
        "Facilities": [
          "Pool",
          "BusinessCenter",
          "WiFi ",
          "DryCleaning",
          " Breakfast"
        ]
      }.as_json

      hotel_model = described_class.new(data).hotel_model
      expect(hotel_model).to have_attributes(
        identifier: 'iJhz',
        destination_id: 5432,
        name: 'Beach Villas Singapore',
        latitude: 1.264751,
        longitude: 103.824006,
        address: ' 8 Sentosa Gateway, Beach Villas ',
        city: 'Singapore',
        postal_code: '098269',
        description: '  This 5 star hotel is located on the coastline of Singapore.',
        amenities_keywords: [
          "Pool",
          "BusinessCenter",
          "WiFi ",
          "DryCleaning",
          " Breakfast"
        ]
      )
    end
  end

  describe 'self.from_array' do
  end
end
