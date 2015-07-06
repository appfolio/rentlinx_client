module Rentlinx
  class StateValidator < BaseValidator
    private

    def validate
      return if @value.nil? || @value == '' || @value.size == 2
      @error = "#{@value} is not a valid state, states must be two characters (CA)"
    end
  end
end
