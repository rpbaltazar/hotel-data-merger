# frozen_string_literal: true

module ServiceProviders
  module Patagonia
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      SOURCE_NAME = 'patagonia'
      SERVICE_PROVIDER_IDENTIFIER_KEY = 'id'

      KEY_MAPPER = {
        name: { service_provider_attribute_name: 'name' },
        destination_id: { service_provider_attribute_name: 'destination' },
        latitude: { service_provider_attribute_name: 'lat' },
        longitude: { service_provider_attribute_name: 'lng' },
        address: { service_provider_attribute_name: 'address' },
        description: { service_provider_attribute_name: 'info' },
        amenities: { service_provider_attribute_name: 'amenities' },
        images: { service_provider_attribute_name: 'images' }
      }.freeze

      private

      def standardize_images(images_object)
        Image.room_types.each_value.each do |key|
          images_per_room_type = images_object[key]
          next if images_per_room_type.nil?

          images_per_room_type.each do |link_caption|
            link_caption['link'] = link_caption['url']
            link_caption.delete('url')
          end
          images_object[key] = images_per_room_type
        end

        images_object
      end
    end
  end
end
