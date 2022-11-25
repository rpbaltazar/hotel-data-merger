# frozen_string_literal: true

class HotelBlueprint < Blueprinter::Base
  identifier :identifier, name: :id

  fields :destination_id, :name, :description, :amenities, :images, :booking_conditions

  field :location do |hotel, _options|
    {
      lat: hotel.latitude,
      lng: hotel.longitude,
      address: hotel.address,
      city: hotel.city,
      country: hotel.country
    }
  end
end
