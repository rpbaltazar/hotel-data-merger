# frozen_string_literal: true

module ServiceProviders
  class DataFetcherRegistry
    # NOTE: Adding a new data source, implies adding a new source to HotelRawDatum source enum
    DATA_FETCHERS = {
      acme: ServiceProviders::Acme::DataFetcher,
      paperflies: ServiceProviders::Paperflies::DataFetcher,
      patagonia: ServiceProviders::Patagonia::DataFetcher
    }.freeze

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
