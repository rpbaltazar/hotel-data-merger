# frozen_string_literal: true

require 'rails_helper'

describe API::V1::HotelsController do
  let(:controller_path) { '/api/v1/hotels' }

  context 'index' do
    let(:request_path) { "#{controller_path}/" }
    let(:request) { get request_path, as: :json }

    it 'returns an array of hotels' do
      request

      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data).to eq []
    end
  end
end
