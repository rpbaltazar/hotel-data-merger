# frozen_string_literal: true

module MergeUtils
  def self.longest_string(array_of_strings)
    array_of_strings.max_by(&:length)
  end

  def self.first_double(array_of_values)
    array_of_values.find { |val| val.is_a? BigDecimal }
  end
end
