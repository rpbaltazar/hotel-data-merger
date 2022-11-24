# frozen_string_literal: true

module API
  module V1
    class HotelsController < ApplicationController
      def index
        render json: { message: 'ok' }
      end
    end
  end
end
