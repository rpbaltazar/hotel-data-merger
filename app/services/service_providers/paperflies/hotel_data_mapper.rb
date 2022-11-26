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

      private

      def standardize_images(images_object)
        Image.room_types.each_value.each do |key|
          images_per_room_type = images_object[key]
          next if images_per_room_type.nil?

          images_per_room_type.each do |link_caption|
            link_caption['description'] = link_caption['caption']
            link_caption.delete('caption')
          end
          images_object[key] = images_per_room_type
        end

        images_object
      end
    end
  end
end
