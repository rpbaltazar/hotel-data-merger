# frozen_string_literal: true

module ServiceProviders
  module Patagonia
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      KEY_MAPPER = {
        identifier: { service_provider_attribute_name: 'id' },
        name: { service_provider_attribute_name: 'name' },
        destination_id: { service_provider_attribute_name: 'destination' },
        latitude: { service_provider_attribute_name: 'lat' },
        longitude: { service_provider_attribute_name: 'lng' },
        address: { service_provider_attribute_name: 'address' },
        description: { service_provider_attribute_name: 'info' },
        amenities: { service_provider_attribute_name: 'amenities' }
      }.freeze
    end
  end
end
