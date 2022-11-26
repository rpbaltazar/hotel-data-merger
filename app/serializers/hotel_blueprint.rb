# frozen_string_literal: true

class HotelBlueprint < Blueprinter::Base
  identifier :identifier, name: :id

  fields :destination_id, :name, :description, :amenities, :booking_conditions

  field :location do |hotel, _options|
    {
      lat: hotel.latitude,
      lng: hotel.longitude,
      address: hotel.address,
      city: hotel.city,
      country: hotel.country
    }
  end

  field :images do |hotel, _options|
    hotel.images.group_by(&:room_type).each_with_object({}) do |room_based_images, hotel_images|
      room_type, images_array = room_based_images
      rendered_images = ImageBlueprint.render_as_json(images_array)
      hotel_images[room_type] = rendered_images
      hotel_images
    end
  end
end
