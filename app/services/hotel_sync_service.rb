# frozen_string_literal: true

require 'merge_utils'

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
      p "Buidling data for identifier #{identifier}"
      raw_data = HotelRawDatum.where(identifier: identifier)
      hotel_attributes = build_hotel_attributes_from_raw_data(raw_data)
      hotel = Hotel.find_or_initialize_by(identifier: identifier)
      hotel.update!(hotel_attributes)
    end
  end

  def build_hotel_attributes_from_raw_data(raw_data)
    # NOTE: These two attributes are always sanitized and matching the identifier so we can
    # safely get the value from any of the raw data records
    destination_id = raw_data.first.destination_id

    {
      destination_id: destination_id,
      name: MergeUtils.longest_string(raw_data.map(&:name).compact),
      latitude: MergeUtils.first_double(raw_data.map(&:latitude).compact),
      longitude: MergeUtils.first_double(raw_data.map(&:longitude).compact),
      address: MergeUtils.longest_string(raw_data.map(&:address).compact),
      city: raw_data.map(&:city).compact.first, # Merging logic for city: first non nil wins
      # NOTE: country should be stored standardized in raw data already, so choosing the first is safe
      country: raw_data.map(&:country).compact.first,
      description: MergeUtils.longest_string(raw_data.map(&:description).compact),
      amenities: fetch_amenities(raw_data.map(&:amenities).compact),
      images: fetch_images(raw_data.map(&:images).compact),
      booking_conditions: fetch_booking_conditions(raw_data.map(&:booking_conditions).compact),
      last_generated_at: Time.now
    }
  end

  # Merging logic for amenities: TODO
  def fetch_amenities(raw_amenities)
    raw_amenities.first
  end

  # Merging logic for images: TODO
  def fetch_images(raw_images)
    final_images = { 'rooms' => [], 'amenities' => [], 'site' => [] }
    raw_images.each do |raw_image_set|
      ['rooms', 'amenities', 'site'].each do |room_type|
        images_to_append = raw_image_set[room_type] || []
        final_images[room_type] += images_to_append
      end
    end

    # TODO: clean duplicates
    final_images
  end

  # Merging logic for booking_conditions: all merged and uniqued
  def fetch_booking_conditions(raw_booking_conditions)
    raw_booking_conditions.flatten.uniq
  end
end
