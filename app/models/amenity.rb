# frozen_string_literal: true

class Amenity < ApplicationRecord
  enum room_type: { room: 'room', general: 'general' }
  belongs_to :hotel
end
