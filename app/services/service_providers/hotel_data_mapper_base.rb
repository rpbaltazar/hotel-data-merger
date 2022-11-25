# frozen_string_literal: true

require 'iso_country_codes'

module ServiceProviders
  class HotelDataMapperBase
    # TODO: return created record ids and updated record ids
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

    def hotel_identifier
      @data[self.class::SERVICE_PROVIDER_IDENTIFIER_KEY]
    end

    def build_hotel_model
      hotel_raw_data = HotelRawDatum.find_or_initialize_by(identifier: hotel_identifier, source: self.class::SOURCE_NAME)

      self.class::KEY_MAPPER.each do |model_attribute, mapped_properties|
        raw_data_key = mapped_properties[:service_provider_attribute_name]
        clean_value = cleanup_data(@data.dig(*raw_data_key))
        standardized_value = standardize_value(clean_value, model_attribute)
        hotel_raw_data.send("#{model_attribute}=", standardized_value)
      end

      hotel_raw_data.save!
      hotel_raw_data
    end

    def standardize_value(clean_value, model_attribute)
      attributes_to_standardize = [:country, :amenities, :images]
      return clean_value unless attributes_to_standardize.include? model_attribute

      case model_attribute
      when :country
        standardize_country(clean_value)
      when :amenities
        clean_value # TODO
      when :images
        standardize_images(clean_value)
      end
    end

    def standardize_images(clean_value)
      clean_value
    end

    def standardize_country(clean_value)
      return nil unless clean_value

      iso_country = find_by_country_code(clean_value)
      iso_country ||= find_by_country_name(clean_value)

      return nil unless iso_country

      iso_country.name
    end

    def find_by_country_code(value)
      IsoCountryCodes.find(value)
    rescue IsoCountryCodes::UnknownCodeError => _e
      nil
    end

    def find_by_country_name(value)
      IsoCountryCodes.search_by_name(value).first
    rescue IsoCountryCodes::UnknownCodeError => _e
      nil
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
