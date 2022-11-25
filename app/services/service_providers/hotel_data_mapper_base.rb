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
      hotel_raw_data = HotelRawDatum.new

      self.class::KEY_MAPPER.each do |model_attribute, mapped_properties|
        raw_data_key = mapped_properties[:service_provider_attribute_name]
        clean_value = cleanup_data(@data.dig(*raw_data_key))
        hotel_raw_data.send("#{model_attribute}=", clean_value)
      end

      hotel_raw_data
    end

    # TODO: Belongs to a utilities class
    def cleanup_data(polluted_value)
      case polluted_value
      when String
        polluted_value.squish
      when Array
        polluted_value.map do |value|
          cleanup_data(value)
        end
      else
        polluted_value
      end
    end
  end
end
