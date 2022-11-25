# frozen_string_literal: true

class HotelFinder
  # Will call multiple service providers in order to find the information about the hotels
  # filtered by the parameters sent
  #
  # @param destination_id [Integer] destination id that we plan to match in the service provider
  # @param hotel_ids [Array<Integer>] list of hotel ids that we plan to match in the service provider
  # @return [Array<Hotel>] array of hotels that match the passed params.
  def self.call(destination_id: nil, hotel_ids: [])
    # TODO: ensure that either is set once we support filtering
    new(destination_id, hotel_ids).call
  end

  def initialize(destination_id, hotel_ids)
    @destination_id = destination_id
    @hotel_ids = hotel_ids
  end

  def call
    hotels = Hotel.all
    hotels = hotels.where(destination_id: @destination_id) if @destination_id.present?
    hotels = hotels.where(identifier: @hotel_ids) if @hotel_ids.present?
    hotels
  end
end
