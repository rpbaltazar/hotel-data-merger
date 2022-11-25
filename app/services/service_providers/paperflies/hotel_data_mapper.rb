# frozen_string_literal: true

module ServiceProviders
  module Paperflies
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      SOURCE_NAME = 'paperflies'

      SERVICE_PROVIDER_IDENTIFIER_KEY = 'hotel_id'

      KEY_MAPPER = {
        name: { service_provider_attribute_name: 'hotel_name' },
        destination_id: { service_provider_attribute_name: 'destination_id' },
        address: { service_provider_attribute_name: %w[location address] },
        country: { service_provider_attribute_name: %w[location country] },
        description: { service_provider_attribute_name: 'details' },
        amenities: { service_provider_attribute_name: 'amenities' },
        booking_conditions: { service_provider_attribute_name: 'booking_conditions' },
        images: { service_provider_attribute_name: 'images' }
      }.freeze
    end
  end
end
