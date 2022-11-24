# frozen_string_literal: true

class HotelBlueprint < Blueprinter::Base
  identifier :identifier, name: :id

  # TODO: Add remaining attributes when data modeling is defined
  fields :name, :description, :destination_id, :latitude, :longitude, :address, :city, :country, :postal_code, :amenities_keywords, :booking_conditions
end
