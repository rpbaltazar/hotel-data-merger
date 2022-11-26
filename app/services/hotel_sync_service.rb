# frozen_string_literal: true

class HotelSyncService
  def self.call
    new.call
  end

  def call
    ServiceProviders::DataFetcherRegistry::DATA_FETCHERS.each_value(&:call)
    regenerate_hotel_data
  end

  private

  def regenerate_hotel_data
    existing_identifiers = HotelRawDatum.select(:identifier).distinct.pluck(:identifier)
    existing_identifiers.each do |identifier|
      raw_data = HotelRawDatum.where(identifier: identifier)
      hb = HotelBuilder.new(identifier: identifier, raw_data: raw_data)
      hb.create_or_update_hotel_record
    end
  end
end
