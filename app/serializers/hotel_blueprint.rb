# frozen_string_literal: true

class HotelBlueprint < Blueprinter::Base
  identifier :identifier, name: :id

  # TODO: Add remaining attributes when data modeling is defined
  fields :name, :description, :destination_id
end
