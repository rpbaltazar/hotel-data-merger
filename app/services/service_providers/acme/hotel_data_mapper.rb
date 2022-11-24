# frozen_string_literal: true

module ServiceProviders
  module Acme
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      KEY_MAPPER = {
        identifier: { raw_attribute: 'Id' },
        name: { raw_attribute: 'Name' },
        destination_id: { raw_attribute: 'DestinationId' },
        latitude: { raw_attribute: 'Latitude' },
        longitude: { raw_attribute: 'Longitude' },
        address: { raw_attribute: 'Address' },
        city: { raw_attribute: 'City' },
        country: { raw_attribute: 'Country' },
        postal_code: { raw_attribute: 'PostalCode' },
        description: { raw_attribute: 'Description' },
        amenities_keywords: { raw_attribute: 'Facilities' }
      }.freeze
    end
  end
end
