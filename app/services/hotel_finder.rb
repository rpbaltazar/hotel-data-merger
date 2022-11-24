# frozen_string_literal: true

class HotelFinder
  #
  def self.call(destination_id: nil, hotel_ids: [])
    # TODO: ensure that either is set once we support filtering
    new(destination_id, hotel_ids).call
  end

  def initialize(destination_id, hotel_ids)
    @destination_id = destination_id
    @hotel_ids = hotel_ids
  end

  def call
    # TODO: Make calls to different service providers
    3.times.map do |i|
      hotel = Hotel.new
      hotel.id = i
      hotel
    end
  end
end
