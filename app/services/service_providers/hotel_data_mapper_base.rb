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
        clean_value = cleanup_data(@data.dig(*raw_data_key))
        hotel.send("#{model_attribute}=", clean_value)
      end

      hotel
    end

    def cleanup_data(polluted_value)
      return unless polluted_value.is_a? String

      polluted_value.squish
    end
  end
end
