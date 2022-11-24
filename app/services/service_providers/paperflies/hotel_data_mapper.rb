# frozen_string_literal: true

module ServiceProviders
  module Paperflies
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      KEY_MAPPER = {
        identifier: { raw_attribute: 'hotel_id' },
        name: { raw_attribute: 'hotel_name' },
        destination_id: { raw_attribute: 'destination_id' },
        address: { raw_attribute: %w[location address] },
        country: { raw_attribute: %w[location country] },
        description: { raw_attribute: 'details' },
        amenities_keywords: { raw_attribute: 'amenities' },
        booking_conditions: { raw_attribute: 'booking_conditions' }
      }.freeze
    end
  end
end
