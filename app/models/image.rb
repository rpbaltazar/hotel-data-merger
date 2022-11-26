# frozen_string_literal: true

class Image < ApplicationRecord
  enum room_type: { rooms: 'rooms', amenities: 'amenities', site: 'site' }
  belongs_to :hotel
end
