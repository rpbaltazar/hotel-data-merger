# frozen_string_literal: true

require 'rails_helper'
require 'merge_utils'

RSpec.describe MergeUtils do
  describe 'longest_string' do
    it 'returns the longest string of an array' do
      arr = %w[one two three four]
      expect(described_class.longest_string(arr)).to eq 'three'
    end
  end

  describe 'first_double' do
    it 'returns the value of the array that is a bigdecimal or a float' do
      big_decimal = BigDecimal('0.3333')

      arr = ['one', 'two', 0.1232, big_decimal]
      expect(described_class.first_double(arr)).to eq 0.1232

      arr = ['one', 'two', big_decimal, 0.1232]
      expect(described_class.first_double(arr)).to eq big_decimal
    end
  end
end
