# frozen_string_literal: true

module MergeUtils
  def self.longest_string(array_of_strings)
    array_of_strings.max_by(&:length)
  end

  def self.first_double(array_of_values)
    acceptable_values = [BigDecimal, Float]
    array_of_values.find { |val| acceptable_values.include?(val.class) }
  end
end
