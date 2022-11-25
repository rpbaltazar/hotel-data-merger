# frozen_string_literal: true

module API
  module V1
    class HotelsController < ApplicationController
      def index
        if invalid_filtering_params
          return render json: { message: 'You must filter by either destination_id or hotel_ids' },
                        status: :unprocessable_entity
        end

        hotels = ::HotelFinder.call(destination_id: index_params[:destination_id], hotel_ids: index_params[:hotel_ids])
        render json: HotelBlueprint.render(hotels)
      end

      private

      def index_params
        params.permit(:destination_id, hotel_ids: [])
      end

      # NOTE: Either destination id or hotel ids must be set but not both at the same time
      def invalid_filtering_params
        (index_params[:destination_id].present? && index_params[:hotel_ids].present?) ||
          (index_params[:destination_id].blank? && index_params[:hotel_ids].blank?)
      end
    end
  end
end
