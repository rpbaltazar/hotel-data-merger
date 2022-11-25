# frozen_string_literal: true

FactoryBot.define do
  factory :hotel do
    sequence :identifier do |n|
      "asDD_#{n}"
    end
    destination_id { 111 }
    name { 'Fantastic hotel' }
  end
end
