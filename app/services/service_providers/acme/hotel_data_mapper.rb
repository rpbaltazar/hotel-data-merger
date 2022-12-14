# frozen_string_literal: true

module ServiceProviders
  module Acme
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
      SOURCE_NAME = 'acme'
      SERVICE_PROVIDER_IDENTIFIER_KEY = 'Id'

      KEY_MAPPER = {
        name: { service_provider_attribute_name: 'Name' },
        destination_id: { service_provider_attribute_name: 'DestinationId' },
        latitude: { service_provider_attribute_name: 'Latitude' },
        longitude: { service_provider_attribute_name: 'Longitude' },
        address: { service_provider_attribute_name: 'Address' },
        city: { service_provider_attribute_name: 'City' },
        country: { service_provider_attribute_name: 'Country' },
        postal_code: { service_provider_attribute_name: 'PostalCode' },
        description: { service_provider_attribute_name: 'Description' },
        amenities: { service_provider_attribute_name: 'Facilities' }
      }.freeze
    end
  end
end
