# frozen_string_literal: true

module ServiceProviders
  module Paperfiles
    class DataFetcher
      def self.call
        new.call
      end

      def initialize
        @service_provider_url = 'https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers'
        @service_provider_connection = Faraday.new(@service_provider_url, request: { timeout: 5 }) do |f|
          f.request :json
          f.response :json
        end
      end

      def call
        response = @service_provider_connection.get('/paperfiles')
        HotelDataMapper.from_array(hotels_data: response.body)
      rescue Faraday::Error => e
        Rails.logger.error(e)
        # TODO: what to do in case of error? Probably return empty data array
      end
    end
  end
end
