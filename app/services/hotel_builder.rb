# frozen_string_literal: true

require 'merge_utils'

class HotelBuilder
  CLOSE_ENOUGH_WORDS_DISTANCE = 3

  def initialize(identifier:, raw_data: [])
    @identifier = identifier
    @raw_data = raw_data
    # NOTE: destination_id is always sanitized and matching the identifier so we can
    # safely get the value from any of the raw data records
    @destination_id = raw_data.first.destination_id
    @hotel = Hotel.find_or_initialize_by(identifier: @identifier, destination_id: @destination_id)
  end

  def create_or_update_hotel_record
    hotel_attributes = build_hotel_attributes_from_raw_data(@raw_data)
    hotel_images = prepare_images(@raw_data.map(&:images).compact)
    hotel_amenities = prepare_amenities(@raw_data.map(&:amenities).compact)
    ActiveRecord::Base.transaction do
      @hotel.update!(hotel_attributes)

      @hotel.images.destroy_all
      @hotel.images = hotel_images

      @hotel.amenities.destroy_all
      @hotel.amenities = hotel_amenities

      @hotel.save!
    end
  end

  private

  def build_hotel_attributes_from_raw_data(raw_data)
    {
      name: MergeUtils.longest_string(raw_data.map(&:name).compact),
      latitude: MergeUtils.first_double(raw_data.map(&:latitude).compact),
      longitude: MergeUtils.first_double(raw_data.map(&:longitude).compact),
      address: MergeUtils.longest_string(raw_data.map(&:address).compact),
      city: raw_data.map(&:city).compact.first, # Merging logic for city: first non nil wins
      # NOTE: country should be stored standardized in raw data already, so choosing the first is safe
      country: raw_data.map(&:country).compact.first,
      description: MergeUtils.longest_string(raw_data.map(&:description).compact),
      booking_conditions: fetch_booking_conditions(raw_data.map(&:booking_conditions).compact),
      last_generated_at: Time.now
    }
  end

  def prepare_images(raw_images)
    hotel_images = []
    raw_images.each do |raw_image_set|
      Image.room_types.each_value do |room_type|
        images_to_append = raw_image_set[room_type] || []
        images_to_append.each do |image|
          next if image_already_in_list(hotel_images, image['link'], room_type)

          hotel_images << Image.new(hotel: @hotel, link: image['link'], description: image['description'], room_type: room_type)
        end
      end
    end
    hotel_images
  end

  def image_already_in_list(hotel_images, new_image_url, new_image_room_type)
    hotel_images.find { |hotel_image| hotel_image.link == new_image_url && hotel_image.room_type == new_image_room_type }
  end

  def prepare_amenities(raw_amenities)
    hotel_amenities_hash = {}

    raw_amenities.each do |raw_amenity_hash|
      room_types = raw_amenity_hash.keys
      room_types.each do |room_type|
        hotel_amenities_hash[room_type] ||= []
        amenities_list = raw_amenity_hash[room_type] || []
        hotel_amenities_hash[room_type] += amenities_list
      end
    end

    hotel_amenities = []
    # NOTE: The order is important because we want to start creating amenities from the more specific to the more general
    %w[room general].each do |room_type|
      hotel_amenities_hash[room_type].each do |amenity|
        next if amenity_already_in_list(hotel_amenities, amenity)

        hotel_amenities << Amenity.new(hotel: @hotel, room_type: room_type, description: amenity)
      end
    end

    hotel_amenities
  end

  def amenity_already_in_list(hotel_amenities, amenity)
    hotel_amenities.find do |hotel_amenity|
      DamerauLevenshtein.distance(hotel_amenity.description.downcase, amenity.downcase) <= CLOSE_ENOUGH_WORDS_DISTANCE
    end
  end

  # Merging logic for booking_conditions: all merged and uniqued
  def fetch_booking_conditions(raw_booking_conditions)
    raw_booking_conditions.flatten.uniq
  end
end
