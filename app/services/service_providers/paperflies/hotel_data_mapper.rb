# frozen_string_literal: true

module ServiceProviders
  module Paperflies
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      KEY_MAPPER = {
        identifier: { service_provider_attribute_name: 'hotel_id' },
        name: { service_provider_attribute_name: 'hotel_name' },
        destination_id: { service_provider_attribute_name: 'destination_id' },
        address: { service_provider_attribute_name: %w[location address] },
        country: { service_provider_attribute_name: %w[location country] },
        description: { service_provider_attribute_name: 'details' },
        # amenities_keywords: { service_provider_attribute_name: 'amenities' },
        # booking_conditions: { service_provider_attribute_name: 'booking_conditions' }
      }.freeze
    end
  end
end
