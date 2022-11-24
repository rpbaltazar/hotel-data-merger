# frozen_string_literal: true

module ServiceProviders
  module Patagonia
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
        response = @service_provider_connection.get('/patagonia')
        HotelDataMapper.from_array(hotels_data: response.body)
      rescue Faraday::Error => e
        Rails.logger.error(e)
        []
      end
    end
  end
end
