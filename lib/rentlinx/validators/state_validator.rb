module Rentlinx
  class StateValidator < BaseValidator
    def validate
      return if @value.nil? || @value == '' || @value.size == 2
      @error = "#{@value} is not a valid state"
    end
  end
end
