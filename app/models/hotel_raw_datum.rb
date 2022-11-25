# frozen_string_literal: true

class HotelRawDatum < ApplicationRecord
  enum source: { patagonia: 'patagonia', acme: 'acme', paperflies: 'paperflies' }
end
