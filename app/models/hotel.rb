# frozen_string_literal: true

class Hotel < ApplicationRecord
  # attr_accessor :id, :identifier, :name, :description, :latitude, :longitude, :address, :city, :country,
  #               :postal_code, :destination_id, :amenities_keywords, :booking_conditions, :images

  # MERGEABLE_ATTRIBUTES = %i[description address city country postal_code booking_conditions].freeze
  MERGEABLE_ATTRIBUTES = %i[description address city country].freeze
end
