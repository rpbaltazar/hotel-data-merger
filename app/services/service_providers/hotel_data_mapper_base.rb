# frozen_string_literal: true

module ServiceProviders
  class HotelDataMapperBase
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

      self.class::KEY_MAPPER.each do |model_attribute, value|
        raw_data_key = value[:raw_attribute]
        hotel.send("#{model_attribute}=", @data.dig(*raw_data_key))
      end

      hotel
    end
  end
end
