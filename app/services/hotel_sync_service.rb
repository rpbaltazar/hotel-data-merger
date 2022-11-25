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
      name: fetch_name(raw_data.pluck(:name).compact),
      latitude: fetch_latitude(raw_data.pluck(:latitude).compact),
      longitude: fetch_longitude(raw_data.pluck(:longitude).compact),
      address: fetch_address(raw_data.pluck(:address).compact),
      city: fetch_city(raw_data.pluck(:city).compact),
      country: fetch_country(raw_data.pluck(:country).compact),
      description: fetch_description(raw_data.pluck(:description).compact),
      amenities: fetch_amenities(raw_data.pluck(:amenities).compact),
      images: fetch_images(raw_data.pluck(:images).compact),
      booking_conditions: fetch_booking_conditions(raw_data.pluck(:booking_conditions).compact),
      last_generated_at: Time.now
    }
  end

  # Merging logic for name: Longest clean name wins
  def fetch_name(raw_names)
    raw_names.max_by(&:length)
  end

  # Merging logic for latitude and longitude: First double wins
  def fetch_latitude(raw_latitudes)
    raw_latitudes.find { |lat| lat.is_a? BigDecimal }
  end

  def fetch_longitude(raw_longitudes)
    raw_longitudes.find { |lat| lat.is_a? BigDecimal }
  end

  # Merging logic for address: Longest clean address wins
  def fetch_address(raw_addresses)
    raw_addresses.max_by(&:length)
  end

  # Merging logic for city: first non nil wins
  def fetch_city(raw_cities)
    raw_cities.first
  end

  # Merging logic for country: first non nil wins. They should be stored standardized in raw data already
  def fetch_country(raw_countries)
    raw_countries.first
  end

  # Merging logic for name: Longest clean name wins
  def fetch_description(raw_descriptions)
    raw_descriptions.max_by(&:length)
  end

  # Merging logic for amenities: TODO
  def fetch_amenities(raw_amenities)
    raw_amenities.first
  end

  # Merging logic for images: TODO
  def fetch_images(raw_images)
    raw_images.first
  end

  # Merging logic for booking_conditions: all merged and uniqued
  def fetch_booking_conditions(raw_booking_conditions)
    raw_booking_conditions.flatten.uniq
  end
end
