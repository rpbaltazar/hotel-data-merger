# frozen_string_literal: true

module ServiceProviders
  module Patagonia
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      KEY_MAPPER = {
        identifier: { raw_attribute: 'id' },
        name: { raw_attribute: 'name' },
        destination_id: { raw_attribute: 'destination' },
        latitude: { raw_attribute: 'lat' },
        longitude: { raw_attribute: 'lng' },
        address: { raw_attribute: 'address' },
        description: { raw_attribute: 'info' },
        amenities_keywords: { raw_attribute: 'amenities' }
      }.freeze
    end
  end
end
