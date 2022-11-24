# frozen_string_literal: true

module ServiceProviders
  module Patagonia
    class HotelDataMapper < ServiceProviders::HotelDataMapperBase
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
