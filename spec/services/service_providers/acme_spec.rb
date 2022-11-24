# frozen_string_literal: true

require 'rails_helper'

describe ServiceProviders::Acme do
  describe 'when acme returns successfully hotel data' do
    it 'returns an array of hotel models based on the data' do
      response = described_class.call
      expect(response.map(&:identifier)).to match_array %w[iJhz SjyX]
    end
  end
end
