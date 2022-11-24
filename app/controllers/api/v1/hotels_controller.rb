# frozen_string_literal: true

module API
  module V1
    class HotelsController < ApplicationController
      def index
        # TODO: invoke api call to different service providers
        hotels = ::HotelFinder.call(destination_id: nil, hotel_ids: [])
        render json: HotelBlueprint.render(hotels)
      end
    end
  end
end
