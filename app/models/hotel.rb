# frozen_string_literal: true

class Hotel < ApplicationRecord
  has_many :images
  has_many :amenities
end
