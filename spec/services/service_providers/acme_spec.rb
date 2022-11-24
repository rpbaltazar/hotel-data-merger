# frozen_string_literal: true

require 'rails_helper'

describe ServiceProviders::Acme do
  def stub_success_response(response_body)
    stub_request(:get, 'https://5f2be0b4ffc88500167b85a0.mockapi.io/acme')
      .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v2.7.1'
            })
      .to_return(status: 200, body: response_body, headers: {})
  end

  describe 'when acme returns successfully hotel data' do
    let(:hotel_raw_data) do
      [{ 'Id' => 'SjyX' }, { 'Id' => 'iJhz' }]
    end

    it 'returns an array of hotel models based on the data' do
      stub_success_response(hotel_raw_data)

      response = described_class.call
      expect(response.map(&:identifier)).to match_array %w[iJhz SjyX]
    end
  end
end
