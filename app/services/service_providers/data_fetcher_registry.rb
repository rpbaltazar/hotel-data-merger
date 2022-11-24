# frozen_string_literal: true

module ServiceProviders
  class DataFetcherRegistry
    DATA_FETCHERS = {
      acme: ServiceProviders::Acme::DataFetcher,
      paperflies: ServiceProviders::Paperflies::DataFetcher,
      patagonia: ServiceProviders::Patagonia::DataFetcher
    }.freeze

    def self.fetch_all
      final_hotel_list = {}
      # TODO: We could probably improve this performance using EM-Synchrony and spawn
      # the 3 requests in parallel
      hotels_per_provider = DATA_FETCHERS.values.each.map(&:call)

      # TODO: Think of ways to improve this logic
      hotels_per_provider.each do |provider_hotels|
        provider_hotels.each do |provider_hotel|
          cached_hotel = final_hotel_list[provider_hotel.identifier]
          final_hotel_list[provider_hotel.identifier] = if cached_hotel.nil?
                                                          provider_hotel
                                                        else
                                                          merge_hotel_info(cached_hotel, provider_hotel)
                                                        end
        end
      end

      final_hotel_list.values
    end

    # TODO: This should be a service of its own
    def self.merge_hotel_info(cached_hotel, new_info)
      ::Hotel::MERGEABLE_ATTRIBUTES.each do |attribute|
        current_attribute_value = cached_hotel.send(attribute)
        new_attribute_value = new_info.send(attribute)

        if current_attribute_value.blank? && new_attribute_value.present?
          cached_hotel.send("#{attribute}=", new_attribute_value)
        end

        if current_attribute_value.present? && new_attribute_value.present?
          if current_attribute_value.length < new_attribute_value.length
            cached_hotel.send("#{attribute}=", new_info.send(attribute))
          end
        end
      end

      cached_hotel
    end
  end
end
