# frozen_string_literal: true

module API
  module V1
    class HotelsController < ApplicationController
      def index
        render json: []
      end
    end
  end
end
