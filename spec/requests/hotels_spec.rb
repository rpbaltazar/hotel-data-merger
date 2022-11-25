# frozen_string_literal: true

require 'rails_helper'

describe API::V1::HotelsController do
  let(:controller_path) { '/api/v1/hotels' }

  context 'index' do
    let(:request_path) { "#{controller_path}/" }
    let(:request) { get request_path, as: :json }
    let(:hotels) { FactoryBot.create_list :hotel, 3 }

    before do
      hotels
    end

    describe 'when no filtering params are sent' do
      it 'returns an error with a meaningful message' do
        request

        expect(response).to have_http_status(422)
        data = JSON.parse(response.body)
        expect(data['message']).to eq 'You must filter by either destination_id or hotel_ids'
      end
    end

    describe 'when both filtering options are sent' do
      let(:request_path) { "#{controller_path}/?destination_id=123&hotel_ids[]=12&hotel_ids[]=13" }

      it 'returns an array of hotels' do
        request

        expect(response).to have_http_status(422)
        data = JSON.parse(response.body)
        expect(data['message']).to eq 'You must filter by either destination_id or hotel_ids'
      end
    end

    describe 'when filtering by hotel ids' do
      let(:request_path) { "#{controller_path}/?hotel_ids[]=#{hotels.first.identifier}&hotel_ids[]=#{hotels.second.identifier}" }

      it 'returns an array of hotels' do
        request

        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)
        expect(data.count).to eq 2
      end
    end

    describe 'when filtering by destination id' do
      let(:request_path) { "#{controller_path}/?destination_id=111" }

      it 'returns an array of hotels' do
        request

        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)
        expect(data.count).to eq 3
      end
    end
  end
end
