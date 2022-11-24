# frozen_string_literal: true

module API
  module V1
    class HotelsController < ApplicationController
      def index
        hotels = ::HotelFinder.call(destination_id: nil, hotel_ids: [])
        # TODO: invoke api call to different service providers
        # TODO: return rendered matched hotels
        render json: []
      end
    end
  end
end
