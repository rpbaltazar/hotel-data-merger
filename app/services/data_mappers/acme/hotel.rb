# frozen_string_literal: true

module DataMappers
  module Acme
    class Hotel
      def self.from_array(hotels_data: [])
        # TODO: Handle scenario where hotels_data is not an array
        hotels_data.map do |hotel_data|
          new(hotel_data).hotel_model
        end
      end

      def initialize(service_provider_response)
        @data = service_provider_response
      end

      def hotel_model
        @hotel_model ||= build_hotel_model
      end

      private

      def build_hotel_model
        hotel = ::Hotel.new
        hotel.identifier = @data["Id"]
        hotel.name = @data["Name"]
        hotel.latitude = @data["Latitude"]
        hotel.longitude = @data["Longitude"]
        hotel.address = @data["Address"]
        hotel.city = @data["City"]
        hotel.country = @data["Country"]
        hotel.postal_code = @data["PostalCode"]
        hotel.description = @data["Description"]
        hotel.destination_id = @data["DestinationId"]
        hotel.amenities_keywords = @data["Facilities"]
        hotel
      end
    end
  end
end
